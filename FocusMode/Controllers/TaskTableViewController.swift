//
//  TaskTableViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    var db: Database!
    var tasks = [Todo]()
    
    
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
        
        loadTodos()
        
        // Observer for handling new task
        let nc = NotificationCenter.default
        nc.addObserver(self, selector:#selector(reloadWithNewTask), name: NSNotification.Name ("newTask"), object: nil)
    }
    
    func loadTodos() {
        let uid = UserDefaults.standard.string(forKey: "uid")!
        
        self.db.getTodos(uid: uid, completion: { (todos, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tasks = todos!
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func reloadWithNewTask(_ notification: Notification) {
        let task = notification.userInfo?["task"] as! Todo
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
        cell.dateLabel.text = parseDTM_toStr(task.dueDate)
        
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
    
    // MARK: - Private Methods
    
    private func parseDTM_toStr(_ dtm: DTM) -> String {
        let str = String(format: "%02d/%02d/%02d, %02d:%02d ",
                         dtm.month, dtm.day, dtm.year,
                         dtm.hour, dtm.minute)
        return str + dtm.amPm
    }
}
