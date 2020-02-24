//
//  TaskDetailsViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var priorityPicker: UISegmentedControl!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var subjectPicker: UIPickerView!
    
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
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        
        self.subjectPicker.delegate = self
        self.subjectPicker.dataSource = self
        subjectPicker.selectRow(2, inComponent: 0, animated: true)
        
        titleTextView.becomeFirstResponder()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        let uid = UserDefaults.standard.string(forKey: "uid")!
        
        getTodo(completion: { (todo, err) in
            if let err = err {
                print("Error getting todo: \(err)")
            } else {
                // [START saving todo in the database]
                self.db.addTodo(uid: uid, todo: todo!, completion: { (todo, err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        self.notifyChange(todo!)
                        self.db.incrementTasksCreated(uid: uid)
                        self.dismiss(animated: true)
                    }
                })
                // [END saving todo in the database]
            }
        })
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapContentView(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return CATEGORY_PICKER_DATA.count
        }
        return SUBJECT_PICKER_DATA.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return CATEGORY_PICKER_DATA[row]
        }
        return SUBJECT_PICKER_DATA[row]
    }
    
    // MARK: - Private Methods
    
    private func getTodo(completion: @escaping (Todo?, Error?) -> Void) {
        let title = titleTextView.text!
        let date = DTM(dueDatePicker)
        let category = CATEGORY_PICKER_DATA[categoryPicker.selectedRow(inComponent: 0)]
        let subject = SUBJECT_PICKER_DATA[subjectPicker.selectedRow(inComponent: 0)]
        let rawPriority = 2 - priorityPicker.selectedSegmentIndex
        
        let todo = Todo(tid: nil, title: title, dueDate: date,
                        category: category, subject: subject,
                        rawPriority: rawPriority)
        
        getInitialPredictions(todo: todo, completion: { (todo, err) in
            if let err = err {
                completion(nil, err)
            } else {
                completion(todo, nil)
            }
        })
    }
    
    private func notifyChange(_ todo: Todo) {
        // Send notification to reload task table view controller
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name("newTodo"), object: nil, userInfo: ["newTodo": todo])
    }
}
