//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    @IBOutlet weak var rateExperience: UISegmentedControl!
    @IBOutlet weak var rateTask: UISlider!
    @IBOutlet weak var ratePlace: UISlider!
    
    var todo: Todo!
    var db: Database!
    var workingPlace: PlaceShort? = nil
    var minutesWorked: Int!
    var distractions: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Database
        db = Database()
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        let experience = Double(rateExperience.selectedSegmentIndex)
        let taskRating = Double(rateTask.value) - experience
        let placeRating = Double(ratePlace.value) - experience
        
        // Update Place in database
        if workingPlace != nil {
            let name = workingPlace?.name
            let location = workingPlace?.location
            let placeID = workingPlace?.placeID
            let type = workingPlace?.type
            let place = Place(name!, location!, placeID!, type!, placeRating, todo.subject, todo.category, minutesWorked, distractions)
            db.addPlace(place: place)
        }
        
        // Create Done task object
        let timeLag = todo.timeLag! + (todo.counter?.used())!
        let overdue = todo.due.minutes(from: Date())
        let done = Done(todo.subject, todo.category, todo.rawPriority, todo.duration!,
                        timeLag, todo.distractions!, todo.breaks!, taskRating, 1, overdue)
        
        let uid = UserDefaults.standard.string(forKey: "uid")!
        
        // Update logs in Database
        db.markTodoDone(uid: uid, tid: todo.tid, done: done)
        db.incrementTasksCompleted(uid: uid)
        
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name("deleteTodo"), object: nil, userInfo: ["deleteTodo": todo!])
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        self.view.window?.rootViewController = tabBarController
    }
}
