//
//  AnimalViewCell.swift
//  VetCare
//
//  Created by Raquel Ramos on 28/04/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit

class AnimalViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalWeight: UILabel!
    @IBOutlet weak var animalOwner: UILabel!
    
    func disp(image: UIImage, name: String, weight: String, owner: String){
        animalImage.image = image
        animalName.text = name
        animalWeight.text = weight
        animalOwner.text = owner
    }
}
