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
        
        let nc = NotificationCenter.default
        
        // Observer for handling new task
        nc.addObserver(self, selector:#selector(reloadWithNewTodo), name: NSNotification.Name ("newTodo"), object: nil)
        
        // Observer for handling completion of a task
        nc.addObserver(self, selector:#selector(deleteTodo), name: NSNotification.Name ("deleteTodo"), object: nil)
        
        // Observer for handling progress of a task
        nc.addObserver(self, selector:#selector(updateTodo), name: NSNotification.Name ("updateTodo"), object: nil)
    }
    
    func loadTodos() {
        let uid = UserDefaults.standard.string(forKey: "uid")!
        
        self.db.getTodos(uid: uid, completion: { (todos, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tasks = todos!.sorted(by: { $0.due.isEarlier(from: $1.due) })
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func deleteTodo(_ notification: Notification) {
        let todo = notification.userInfo?["deleteTodo"] as! Todo
        for i in 0..<tasks.count {
            if tasks[i].tid == todo.tid {
                tasks.remove(at: i)
                break
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func reloadWithNewTodo(_ notification: Notification) {
        let todo = notification.userInfo?["newTodo"] as! Todo
        self.tasks.append(todo)
        self.tasks.sort(by: { $0.due.isEarlier(from: $1.due) })
        self.tableView.reloadData()
    }
    
    @objc func updateTodo(_ notification: Notification) {
        let todo = notification.userInfo?["updateTodo"] as! Todo
        for i in 0..<tasks.count {
            if tasks[i].tid == todo.tid {
                tasks[i] = todo
                break
            }
        }
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
        cell.dateLabel.text = task.due.toString()
        
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
