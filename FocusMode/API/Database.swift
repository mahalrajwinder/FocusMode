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
    
    func addPlace() {
        let uid = UserDefaults.standard.string(forKey: "uid")!
        let location = Location(33.64582920000001, -117.8468481)
        let place = Place("Science Library", location, "ChIJlYc2bhHe3IAR2uGqbK_4Gxc",
                          "library", 4.6, "CS_or_Engineering", "Project", 130, 15)
        
        self.db.collection("places").document(uid).setData([
            "\(place.placeID)": place.toDict()
        ], merge: true) { err in
            if let err = err {
                print(err)
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
    
    func markTodoDone(uid: String, todo: Todo) {
        let tasksRef = self.db.collection("tasks").document(uid)
        
        // [START Adding task to done collection]
        let status = 1
        let overdue = -30
        let rating = 7.5
        let duration = 60
        let timeLag = 70
        let distractions = 12
        let breaks = 4
        
        let key = "\(todo.subject),\(todo.category)"
        let docRef = tasksRef.collection("done").document(key)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var done = Done(key, document.data()!)
                done.log(todo.rawPriority, duration, timeLag,
                         distractions, breaks, rating, status, overdue)
                docRef.setData(done.toDict(), merge: true) { err in
                    if let err = err {
                        print("Error marking task done: \(err)")
                    }
                }
            } else {
                let done = Done(todo.subject, todo.category, todo.rawPriority,
                                duration, timeLag, distractions, breaks,
                                rating, status, overdue)
                docRef.setData(done.toDict()) { err in
                    if let err = err {
                        print("Error marking task done: \(err)")
                    }
                }
            }
        }
        // [END Adding task to done collection]
        
        // [START deleting task from todo collection]
        tasksRef.collection("todo").document(todo.tid).delete() { err in
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
    
    // MARK: - Private Methods
    
    private func getTodoArray(querySnapshot: QuerySnapshot) -> [Todo] {
        var todos = [Todo]()
        
        for doc in querySnapshot.documents {
            let todo = Todo(doc.documentID, doc.data())
            todos.append(todo)
        }
        return todos
    }
}
