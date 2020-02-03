//
//  TaskCell.swift
//  FocusMode
//
//  Created by Rajwinder on 1/30/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
