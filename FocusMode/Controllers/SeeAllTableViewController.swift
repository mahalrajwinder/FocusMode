//
//  SeeAllTableViewController.swift
//  FocusMode
//
//  Created by Rajwinder on 2/24/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class SeeAllTableViewController: UITableViewController {
    
    var places: [Place]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seeAllPlaceCell", for: indexPath) as! PlaceCell
        
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.ratingLabel.text = "Rating: \(place.getRating())"

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
