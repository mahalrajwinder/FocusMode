//
//  RecommendTableViewController.swift
//  FocusMode
//
//  Created by Rajwinder on 3/5/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class RecommendTableViewController: UITableViewController {
    
    var db: Database!
    var tasks = [Todo]()
    
    
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
                self.tasks = todos!.sorted(by: { self.hasHighPriority($0, $1)})
                // Apply context if user is near a place and one of the task has
                // that place as the preferred place.
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
        self.tasks.sort(by: { self.hasHighPriority($0, $1)})
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
        self.tasks.sort(by: { self.hasHighPriority($0, $1)})
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendCell", for: indexPath) as! RecommendCell
        
        let task = tasks[indexPath.row]
        cell.titleLabel.text = task.title
        cell.dateLabel.text = task.due.toString()
        
        if let counter = task.counter {
            cell.timeLabel.text = counter.toString()
        } else {
            cell.timeLabel.text = Counter(task.duration!).toString()
        }
        
        cell.distractionsLabel.text = String(task.distractions!)
        cell.breaksLabel.text = String(task.breaks!)
        var timeLag = task.timeLag!
        if let pauseTime = task.pauseTime {
            timeLag += Date().minutes(from: pauseTime)
        }
        cell.timeLagLabel.text = Counter(timeLag).toString()
        
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RBeginTaskSegue") {
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
    
    func hasHighPriority(_ lhs: Todo, _ rhs: Todo) -> Bool {
        let lhsUrgency = lhs.due.minutes(from: Date())
        let rhsUrgency = rhs.due.minutes(from: Date())
        
        if lhs.priority == rhs.priority {
            return lhsUrgency < rhsUrgency
        }
        
        var percentageDiff = abs(lhsUrgency - rhsUrgency)
        percentageDiff /= ((lhsUrgency + rhsUrgency) / 2)
        percentageDiff *= 100
        
        if percentageDiff <= 25 {
            return lhs.priority! < rhs.priority!
        }
        
        return lhs.priority! + Int((Double(lhsUrgency) * 0.01)) < rhs.priority! + Int((Double(rhsUrgency) * 0.01))
    }
}
