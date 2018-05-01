//
//  ProfileTableViewCell.swift
//  VetCare
//
//  Created by Raquel Ramos on 30/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageOption: UIImageView!
    @IBOutlet weak var textOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
