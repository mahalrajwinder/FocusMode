//
//  SignUpViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var timePrefPicker: UISegmentedControl!
    @IBOutlet weak var bedtimePicker: UIDatePicker!
    @IBOutlet weak var majorPicker: UIPickerView!
    @IBOutlet weak var studyGoalPicker: UIDatePicker!
    @IBOutlet weak var deadlineMetPicker: UISlider!
    @IBOutlet weak var handlingPrioritiesPicker: UISlider!
    @IBOutlet weak var hardworkingRatePicker: UISlider!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var db: Database!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Database
        db = Database()
        
        self.majorPicker.delegate = self
        self.majorPicker.dataSource = self
        majorPicker.selectRow(2, inComponent: 0, animated: true)
        
        nameTextField.becomeFirstResponder()
        
        errorLabel.isHidden = true
        
        signUpBtn.layer.cornerRadius = 20
        signUpBtn.clipsToBounds = true
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult,  error) in
            guard let user = authResult?.user, error == nil else {
                self.errorLabel.isHidden = false
                print(error!.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(user.uid, forKey: "uid")
            
            self.getProfile(uid: user.uid, completion: { (profile, err) in
                if let err = err {
                    print("Error getting profile: \(err)")
                } else {
                    // [START saving profile in database]
                    self.db.createProfile(profile: profile!, completion: { (err) in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Profile successfully written!)")
                        }
                    })
                    // [END saving profile in database]
                    
                    // [START saving user model in database]
                    self.db.createUserModel(profile: profile!, completion: { (err) in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("User Model successfully written!)")
                        }
                    })
                    // [END saving user model in database]
                }
            })
            
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            self.view.window?.rootViewController = tabBarController
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapContentView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MAJOR_PICKER_DATA.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MAJOR_PICKER_DATA[row]
    }
    
    // MARK: - Private Methods
    
    private func getProfile(uid: String, completion: @escaping (Profile?, Error?) -> Void) {
        let name = nameTextField.text!
        let age = Int(ageTextField.text!)!
        let gender = genderPicker.selectedSegmentIndex == 0 ? "Male" : "Female"
        let height = Double(heightTextField.text!)!
        let weight = Double(weightTextField.text!)!
        let timePref = timePrefPicker.selectedSegmentIndex == 0 ? "morning" : "night"
        let bedtime = TM(bedtimePicker)
        let major = MAJOR_PICKER_DATA[majorPicker.selectedRow(inComponent: 0)]
        let goal = Int(studyGoalPicker.countDownDuration / 60) // in minutes
        let successRate = Double(deadlineMetPicker.value)
        let prioritiesRate = Double(handlingPrioritiesPicker.value)
        let workingRate = Double(hardworkingRatePicker.value)
        
        getCoordsFromAddress(address: addressTextField.text!, completion: { (coords, err) in
            if let err = err {
                completion(nil, err)
            } else {
                let profile = Profile(uid: uid, name: name, age: age, gender: gender,
                                      height: height, weight: weight, address: coords!,
                                      major: major, timePreference: timePref, dailyGoal: goal,
                                      bedtime: bedtime, successRate: successRate,
                                      handlingPrioritiesRate: prioritiesRate,
                                      hardworkingRate: workingRate)
                
                completion(profile, nil)
            }
        })
    }
}
