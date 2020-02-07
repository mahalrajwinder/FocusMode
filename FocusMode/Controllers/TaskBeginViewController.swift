//
//  TaskBeginViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class TaskBeginViewController: UIViewController {
    
    var task: Todo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapStop(_ sender: Any) {
        // TODO: pause the Task
        self.dismiss(animated: true)
    }
}
