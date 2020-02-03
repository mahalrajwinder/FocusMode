//
//  TaskDetailsViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import Firebase

class TaskDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var priorityPicker: UISegmentedControl!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var subjectPicker: UIPickerView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    
    let categoryPickerData: [String] = ["Homework", "Exam", "Quiz", "Project", "Other"]
    let subjectPickerData: [String] = ["Science", "Mathematics", "CS / Engineering", "English / Writing", "Social Studies", "General / Other"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (handle != nil) {
            Auth.auth().removeStateDidChangeListener(handle!) // remove_auth_listener
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START db setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END db setup]
        db = Firestore.firestore()
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        
        self.subjectPicker.delegate = self
        self.subjectPicker.dataSource = self
        subjectPicker.selectRow(2, inComponent: 0, animated: true)
        
        titleTextView.becomeFirstResponder()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        let title = titleTextView.text!
        let priority = 2 - priorityPicker.selectedSegmentIndex
        let category = categoryPickerData[categoryPicker.selectedRow(inComponent: 0)]
        let subject = subjectPickerData[subjectPicker.selectedRow(inComponent: 0)]
        let date = getDateStr(dueDatePicker)
        
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            let uid = user?.uid
            var ref: DocumentReference? = nil
            ref = self.db.collection("tasks").document(uid!).collection("todo").addDocument(data: [
                "title": title,
                "dueDate": date,
                "category": category,
                "subject": subject,
                "priority": priority
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!)")
                }
            }
            
            let tid = ref?.documentID
            let task = Task(tid: tid!, title: title, dueDate: date, category: category, subject: subject, priority: Double(priority))
            
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name("newTask"), object: nil, userInfo: ["task": task])
            
            self.dismiss(animated: true)
        })
        // [END auth_listener]
        
        // TODO:
        // Update user profile to increment tasksCreated field
        // Call other algorithms to calculate other stuff
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapContentView(_ sender: Any) {
        view.endEditing(true)
    }
    
    private func getDateStr(_ datePicker: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        return dateFormatter.string(from: datePicker.date)
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categoryPickerData.count
        }
        return subjectPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categoryPickerData[row]
        }
        return subjectPickerData[row]
    }
}
