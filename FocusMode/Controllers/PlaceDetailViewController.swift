//
//  PlaceDetailViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    
    var place: PlaceShort!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = place.name
        ratingLabel.text = "Rating: \(place.rating)"
        typeLabel.text = "Type: \(place.type)"
        openNowLabel.text = "Open Now: \(place.open_now ? "Yes" : "No")"
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
