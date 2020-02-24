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
        let bedtime = parseTM_toObj(profile.bedtime)
        let address = parseCoordsToObj(profile.address)
                
        self.db.collection("profile").document(profile.uid).setData([
            "name": profile.name,
            "age": profile.age,
            "gender": profile.gender,
            "height": profile.height,
            "weight": profile.weight,
            "timePreference": profile.timePreference,
            "bedtime": bedtime,
            "major": profile.major,
            "dailyGoal": profile.dailyGoal,
            "successRate": profile.successRate,
            "handlingPrioritiesRate": profile.handlingPrioritiesRate,
            "hardworkingRate": profile.hardworkingRate,
            "address": address
        ]) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    func createUserModel(profile: Profile,
                       completion: @escaping (Error?) -> Void) {
        // Get similar user data
        let places = parseCoordsArrayToObj([Coords(0.0, 0.0)])
        let tempRange = ["min": 0.0, "max": 0.0]
        
        self.db.collection("model").document(profile.uid).setData([
            "tasksCreated": 0,
            "tasksCompleted": 0,
            "daysIndex": DAYS_INDEX,
            "mostVisitedPlaces": places,
            "averageDistractions": 0,
            "averageBreakDuration": 0,
            "averageTaskDuration": 0,
            "mostFrequentSubject": "CS",
            "mostFrequentCategory": "HW",
            "mostMissedDeadlinesSubject": "CS",
            "mostMissedDeadlinesCategory": "HW",
            "activity": 0,
            "tempRange": tempRange
        ]) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    func incrementTasksCreated(uid: String) {
        let docRef = db.collection("model").document(uid)
        
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
    
    
    // MARK: - Todos
    
    func addTodo(uid: String,
                 todo: Todo,
                 completion: @escaping (Todo?, Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = self.db.collection("tasks").document(uid)
        ref = ref?.collection("todo").addDocument(data: [
            "title": todo.title,
            "dueDate": parseDTM_toObj(todo.dueDate),
            "category": todo.category,
            "subject": todo.subject,
            "rawPriority": todo.rawPriority,
            "priority": todo.priority!,
            "predictedDuration": todo.predictedDuration!,
            "startBy": parseDTM_toObj(todo.startBy!),
            "totalBreaks": todo.totalBreaks!,
            "breakDuration": todo.breakDuration!,
            "totalDistractions": todo.totalDistractions!,
            "averageTemp": todo.averageTemp!,
            "prefPlaces": parseCoordsArrayToObj(todo.prefPlaces!),
        ]) { err in
            if let err = err {
                completion(nil, err)
            } else {
                var newTodo = todo
                newTodo.tid = ref?.documentID
                completion(newTodo, nil)
            }
        }
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
        var data: [String: Any]
        
        for doc in querySnapshot.documents {
            data = doc.data()
            let tid = doc.documentID
            let title = data["title"] as! String
            let date = parseObjToDTM(data["dueDate"] as! [String : Any])
            let category = data["category"] as! String
            let subject = data["subject"] as! String
            let rawPriority = data["rawPriority"] as! Int
            let priority = data["priority"] as! Int
            let duration = data["predictedDuration"] as! Int
            let startBy = parseObjToDTM(data["startBy"] as! [String : Any])
            let breaks = data["totalBreaks"] as! Int
            let breakDuration = data["breakDuration"] as! Int
            let distractions = data["totalDistractions"] as! Int
            let temp = data["averageTemp"] as! Double
            let places = parseObjToCoordsArray(data["prefPlaces"] as! [[String : Double]])
            
            var pauseTime: DTM? = nil
            if let ptime = data["pauseTime"] {
                pauseTime = parseObjToDTM(ptime as! [String : Any])
            }
            
            let todo = Todo(tid: tid, title: title, dueDate: date,
                            category: category, subject: subject,
                            rawPriority: rawPriority, priority: priority,
                            predictedDuration: duration, startBy: startBy,
                            pauseTime: pauseTime, totalBreaks: breaks,
                            breakDuration: breakDuration,
                            totalDistractions: distractions,
                            averageTemp: temp, prefPlaces: places)
            todos.append(todo)
        }
        
        return todos
    }
    
    private func parseCoordsArrayToObj(_ coordsArr: [Coords]) -> [[String: Double]] {
        var objArr = [[String: Double]]()
        
        for coords in coordsArr {
            let obj = parseCoordsToObj(coords)
            objArr.append(obj)
        }
        
        return objArr
    }
    
    private func parseObjToCoordsArray(_ obj: [[String: Double]]) -> [Coords] {
        var coordsArr = [Coords]()
        
        for o in obj {
            let coords = parseObjToCoords(o)
            coordsArr.append(coords)
        }
        
        return coordsArr
    }
    
    private func parseCoordsToObj(_ coords: Coords) -> [String: Double] {
        return [
            "lat": coords.lat,
            "long": coords.long,
        ]
    }
    
    private func parseObjToCoords(_ obj: [String: Double]) -> Coords {
        let lat = obj["lat"]!
        let long = obj["long"]!
        
        return Coords(lat, long)
    }
    
    private func parseTM_toObj(_ tm: TM) -> [String: Any] {
        return [
            "hour": tm.hour,
            "minute": tm.minute,
            "amPm": tm.amPm,
        ]
    }
    
    private func parseDT_toObj(_ dt: DT) -> [String: Int] {
        return [
            "year": dt.year,
            "month": dt.month,
            "day": dt.day,
        ]
    }
    
    private func parseDTM_toObj(_ dtm: DTM) -> [String: Any] {
        return [
            "year": dtm.year,
            "month": dtm.month,
            "day": dtm.day,
            "hour": dtm.hour,
            "minute": dtm.minute,
            "amPm": dtm.amPm,
        ]
    }
    
    private func parseObjToTM(_ tm: [String: Any]) -> TM {
        let h = tm["hour"] as! Int
        let m = tm["minute"] as! Int
        let amPm = tm["amPm"] as! String
        
        return TM(h, m, amPm)
    }
    
    private func parseObjToDT(_ dt: [String: Int]) -> DT {
        let y = dt["year"]!
        let m = dt["month"]!
        let d = dt["day"]!
        
        return DT(y, m, d)
    }
    
    private func parseObjToDTM(_ dtm: [String: Any]) -> DTM {
        let y = dtm["year"] as! Int
        let m = dtm["month"] as! Int
        let d = dtm["day"] as! Int
        let h = dtm["hour"] as! Int
        let min = dtm["minute"] as! Int
        let amPm = dtm["amPm"] as! String
        
        return DTM(y, m, d, h, min, amPm)
    }
}
