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
        let todo = getTodo()
        
        self.db.addTodo(uid: uid, todo: todo, completion: { (todo, err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.notifyChange()
                self.db.incrementTasksCreated(uid: uid)
                self.dismiss(animated: true)
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
    
    private func getTodo() -> Todo {
        let title = titleTextView.text!
        let date = DTM(dueDatePicker)
        let category = CATEGORY_PICKER_DATA[categoryPicker.selectedRow(inComponent: 0)]
        let subject = SUBJECT_PICKER_DATA[subjectPicker.selectedRow(inComponent: 0)]
        let rawPriority = 2 - priorityPicker.selectedSegmentIndex
        
        let predictedData = getInitialPredictions(title: title,
                                                  due: date,
                                                  category: category,
                                                  subject: subject,
                                                  rawPriority: rawPriority)
        
        let priority = predictedData["priority"] as! Int
        let duration = predictedData["predictedDuration"] as! Int
        let startBy = predictedData["startBy"] as! DTM
        let tempRange = predictedData["tempRange"] as! [String: Double]
        let prefPlaces = predictedData["prefPlaces"] as! [Coords]
        
        return Todo(tid: nil, title: title, dueDate: date, category: category,
                    subject: subject, priority: priority,
                    predictedDuration: duration, totalBreaks: 0,
                    breakDuration: 0, totalDistractions: 0, startBy: startBy,
                    tempRange: tempRange, prefPlaces: prefPlaces)
    }
    
    private func notifyChange() {
        // Send notification to reload task table view controller
        //let nc = NotificationCenter.default
        //nc.post(name: NSNotification.Name("newTask"), object: nil, userInfo: ["task": task])
    }
}
