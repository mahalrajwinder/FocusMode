//
//  TaskTableViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import Firebase

class TaskTableViewController: UITableViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    var db: Firestore!
    var tasks = [Task]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!) // remove_auth_listener
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START db setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END db setup]
        db = Firestore.firestore()
        
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            let uid = user?.uid
            let todoRef = self.db.collection("tasks").document(uid!).collection("todo")
            
            todoRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let tid = document.documentID
                        let data = document.data()
                        let title = data["title"] as! String
                        let date = data["dueDate"] as! String
                        let category = data["category"] as! String
                        let subject = data["subject"] as! String
                        let priority = data["priority"] as! Double
                        
                        let task = Task(tid: tid, title: title, dueDate: date, category: category, subject: subject, priority: priority)
                        
                        self.tasks.append(task)
                    }
                    self.tableView.reloadData()
                }
            }
        })
        // [END auth_listener]
        
        // Observer for handling new task
        let nc = NotificationCenter.default
        nc.addObserver(self, selector:#selector(reloadWithNewTask), name: NSNotification.Name ("newTask"), object: nil)
    }
    
    @objc func reloadWithNewTask(_ notification: Notification) {
        let task = notification.userInfo?["task"] as! Task
        self.tasks.append(task)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        let task = tasks[indexPath.row]
        cell.titleLabel.text = task.title
        cell.dateLabel.text = task.dueDate
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BeginTaskSegue") {
            // Find the selected task
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let task = tasks[indexPath.row]
            
            // Pass the selected task to the details view controller
            let beginViewController = segue.destination as! TaskBeginViewController
            beginViewController.task = task
            
            // De-selects the selected task cell
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
