//
//  SignInViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
        
        errorLabel.isHidden = true
        
        signInBtn.layer.cornerRadius = 20
        signInBtn.clipsToBounds = true
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                self.errorLabel.isHidden = false
                print(error!.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(user.uid, forKey: "uid")
            
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            self.view.window?.rootViewController = tabBarController
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
