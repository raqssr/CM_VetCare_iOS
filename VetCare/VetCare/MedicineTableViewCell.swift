//
//  MedicineTableViewCell.swift
//  VetCare
//
//  Created by Raquel Ramos on 01/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameMedicine: UILabel!
    @IBOutlet weak var dosage: UILabel!
    @IBOutlet weak var frequency: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
