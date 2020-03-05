//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class RatePlaceViewController: UIViewController {
    
    @IBOutlet weak var ratingSlider: UISlider!
    
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
        let rating = Double(ratingSlider.value)
        let name = workingPlace?.name
        let location = workingPlace?.location
        let placeID = workingPlace?.placeID
        let type = workingPlace?.type
        
        let place = Place(name!, location!, placeID!, type!, rating, todo.subject, todo.category, minutesWorked, distractions)
        
        db.addPlace(place: place)
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        self.view.window?.rootViewController = tabBarController
    }
}
