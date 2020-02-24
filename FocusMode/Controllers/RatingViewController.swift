//
//  RatingViewController.swift
//  FocusMode
//
//  Created by Rajwinder on 2/24/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    var todo: Todo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        // get rating information
        // save todo in the database
        // send notification to referesh task list. Listened by Tasks and Recomendation VC
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        self.view.window?.rootViewController = tabBarController
    }
}
