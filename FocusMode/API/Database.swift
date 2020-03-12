//
//  Database.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Firebase

class Database {
    
    var db: Firestore!
    
    init() {
        // [START db setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END db setup]
        db = Firestore.firestore()
    }
    
    // MARK: - User Profile
    
    func createProfile(profile: Profile,
                       completion: @escaping (Error?) -> Void) {
        
        self.db.collection("profile").document(profile.uid).setData(profile.toDict()) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    func createUserModel(profile: Profile,
                       completion: @escaping (Error?) -> Void) {
        //
        // Create one task of each subject and category for the new user
        // using data from similar users (and taking their averages).
        //
        // Create a temp/uid document with at least 10 places from
        // similar users to recommend places if there is not enough data in
        // user logs.
        
//        HealthKitManager().getTodaysSteps(completion: { (steps) in
//            print("Steps: \(steps)")
//        })
        
        let temp = ["temperatures": 70, "count": 1]
        
        self.db.collection("model").document(profile.uid).setData([
            "tasksCreated": 0,
            "tasksCompleted": 0,
            "daysIndex": DAYS_INDEX,
            "activity": 0,
            "tempRange": temp,
        ]) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    func incrementTasksCreated(uid: String) {
        let docRef = self.db.collection("model").document(uid)
        
        docRef.getDocument(completion: { (doc, err) in
            if let doc = doc, doc.exists {
                let tasksCreated: Int = doc.get("tasksCreated") as! Int
                docRef.setData([
                    "tasksCreated": tasksCreated + 1
                ], merge: true) { err in
                    if let err = err {
                        print("Error incremeenting tasks created: \(err)")
                    }
                }
            }
        })
    }
    
    func incrementTasksCompleted(uid: String) {
        let docRef = self.db.collection("model").document(uid)
        
        docRef.getDocument(completion: { (doc, err) in
            if let doc = doc, doc.exists {
                let tasksCompleted: Int = doc.get("tasksCompleted") as! Int
                docRef.setData([
                    "tasksCompleted": tasksCompleted + 1
                ], merge: true) { err in
                    if let err = err {
                        print("Error incremeenting tasks completed: \(err)")
                    }
                }
            }
        })
    }
    
    // MARK: - Place
    
    func addPlace(place: Place) {
        // Check if placeID already in user logs
        // If so, update logs
        // Otherwise add new location entry to logs
        //print(place)
        let uid = UserDefaults.standard.string(forKey: "uid")!
        let docRef = self.db.collection("places").document(uid)
        print("Gettting")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Got document")
                let p = document.get(place.placeID)
                if p != nil {
                    print("Got place")
                    var newPlace = Place(p as! [String : Any])
                    newPlace.log(place: place)
                    docRef.setData([
                        "\(newPlace.placeID)": newPlace.toDict()
                    ], merge: true) { err in
                        if let err = err {
                            print("Error adding place: \(err)")
                        }
                    }
                    return
                }
            }
            print("Second")
            
            //
            docRef.setData([
                "\(place.placeID)": place.toDict()
            ], merge: true) { err in
                if let err = err {
                    print("Error adding place: \(err)")
                }
            }
        }
    }
    
    func getPlaces(uid: String, completion: @escaping ([Place]?, Error?) -> Void) {
        let docRef = self.db.collection("places").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var places = [Place]()
                
                for (_,v) in document.data()! {
                    let place = Place(v as! [String : Any])
                    places.append(place)
                }
                completion(places, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Todos
    
    func addTodo(uid: String,
                 todo: Todo,
                 completion: @escaping (Todo?, Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = self.db.collection("tasks").document(uid)
        ref = ref?.collection("todo").addDocument(data: todo.toDict()) { err in
            if let err = err {
                completion(nil, err)
            } else {
                var newTodo = todo
                newTodo.tid = ref!.documentID
                completion(newTodo, nil)
            }
        }
    }
    
    func updateTodo(uid: String, todo: Todo) {
        let tasksRef = self.db.collection("tasks")
        let tasks = tasksRef.document(uid)
        let todoRef = tasks.collection("todo").document(todo.tid)
        
        todoRef.setData(todo.toDict(), merge: true) { err in
            if let err = err {
                print("Error updating todo: \(err)")
            }
        }
    }
    
    func markTodoDone(uid: String, tid: String, done: Done) {
        let tasksRef = self.db.collection("tasks").document(uid)
        
        // [START Adding task to done collection]
        let docRef = tasksRef.collection("done").document(done.key)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var oldDone = Done(done.key, document.data()!)
                oldDone.log(done: done)
                docRef.setData(oldDone.toDict(), merge: true) { err in
                    if let err = err {
                        print("Error marking task done: \(err)")
                    }
                }
            } else {
                docRef.setData(done.toDict()) { err in
                    if let err = err {
                        print("Error marking task done: \(err)")
                    }
                }
            }
        }
        // [END Adding task to done collection]
        
        // [START deleting task from todo collection]
        tasksRef.collection("todo").document(tid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
        }
        // [END deleting task from todo collection]
    }
    
    func getTodos(uid: String,
                  completion: @escaping ([Todo]?, Error?) -> Void) {
        let tasksRef = self.db.collection("tasks")
        let tasks = tasksRef.document(uid)
        let todoRef = tasks.collection("todo")
        
        todoRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(nil, err)
            } else {
                let todos = self.getTodoArray(querySnapshot: querySnapshot!)
                completion(todos, nil)
            }
        }
    }
    
    func getDoneTasks(uid: String, subject: String, category: String,
                  completion: @escaping (Done?, Error?) -> Void) {
        let tasksRef = self.db.collection("tasks")
        let tasks = tasksRef.document(uid)
        let doneRef = tasks.collection("done").document("\(subject),\(category)")
        
        doneRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let done = Done(document.documentID, document.data()!)
                completion(done, nil)
            } else {
                // find similar documents
                completion(nil, error)
            }
        }
        
//        doneRef.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                completion(nil, err)
//            } else {
//                let doneTasks = self.getDoneTaskArray(querySnapshot: querySnapshot!)
//                completion(doneTasks, nil)
//            }
//        }
    }
    
    // MARK: - Private Methods
    
    private func getTodoArray(querySnapshot: QuerySnapshot) -> [Todo] {
        var todos = [Todo]()
        
        for doc in querySnapshot.documents {
            let todo = Todo(doc.documentID, doc.data())
            todos.append(todo)
        }
        return todos
    }
    
    private func getDoneTaskArray(querySnapshot: QuerySnapshot) -> [Done] {
        var doneTasks = [Done]()
        
        for doc in querySnapshot.documents {
            let done = Done(doc.documentID, doc.data())
            doneTasks.append(done)
        }
        return doneTasks
    }
}
