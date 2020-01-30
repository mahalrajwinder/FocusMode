//
//  WelcomeViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.layer.cornerRadius = 28
        signUpBtn.clipsToBounds = true
    }
}
