//
//  TaskListTableViewCell.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
