//
//  AuthListener.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Firebase

class AuthListener {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // User is signed in.
                print(user.uid)
            } else {
                // No user is signed in.
            }
        })
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}
