//
//  RecommendCell.swift
//  FocusMode
//
//  Created by Rajwinder on 3/5/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class RecommendCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distractionsLabel: UILabel!
    @IBOutlet weak var breaksLabel: UILabel!
    @IBOutlet weak var timeLagLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
