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
    @IBOutlet weak var genderPicker: UISegmentedControl!
    @IBOutlet weak var timePrefPicker: UISegmentedControl!
    @IBOutlet weak var bedtimePicker: UIDatePicker!
    @IBOutlet weak var majorPicker: UIPickerView!
    @IBOutlet weak var studyGoalPicker: UIDatePicker!
    @IBOutlet weak var deadlineMetPicker: UISlider!
    @IBOutlet weak var handlingPrioritiesPicker: UISlider!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    
//    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    
    
    let majorPickerData: [String] = ["Engineering", "Mathematics", "Computer Science", "Biology", "Social Studies", "Physical Sciences", "Business", "Economics"]
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // [START auth_listener]
//        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
//            print(user?.email! as Any)
//        })
//        // [END auth_listener]
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        Auth.auth().removeStateDidChangeListener(handle!) // remove_auth_listener
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START db setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END db setup]
        db = Firestore.firestore()
        
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
            print("\(user.email!) created")
            
            self.createProfile(uid: user.uid)
            
            let  tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            self.view.window?.rootViewController = tabBarController
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapContentView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func createProfile(uid: String) {
        let name = nameTextField.text!
        let age = Int(ageTextField.text!)
        let height = Double(heightTextField.text!)
        let weight = Double(weightTextField.text!)
        let gender = genderPicker.selectedSegmentIndex == 0 ? "Male" : "Female"
        let timePref = timePrefPicker.selectedSegmentIndex == 0 ? "morning" : "night"
        let bedtime = getBedtime()
        let major = majorPickerData[majorPicker.selectedRow(inComponent: 0)]
        let goal = studyGoalPicker.countDownDuration / 60
        let deadlineSuccessRate = deadlineMetPicker.value
        let prioritiesRate = handlingPrioritiesPicker.value
        self.db.collection("users").document(uid).setData([
            "name": name,
            "age": age!,
            "height": height!,
            "weight": weight!,
            "gender": gender,
            "timePreference": timePref,
            "bedtime": bedtime,
            "major": major,
            "dailyGoal": goal,
            "deadlineSuccessRate": deadlineSuccessRate,
            "handlingPriorities": prioritiesRate,
            "tasksCreated": 0,
            "tasksCompleted": 0
        ], merge: true) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully written!)")
            }
        }
    }
    
    private func getBedtime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        return dateFormatter.string(from: bedtimePicker.date)
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majorPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majorPickerData[row]
    }
}
