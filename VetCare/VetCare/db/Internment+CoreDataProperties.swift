//
//  Internment+CoreDataProperties.swift
//  VetCare
//
//  Created by Raquel Ramos on 22/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Internment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Internment> {
        return NSFetchRequest<Internment>(entityName: "Internment")
    }

    @NSManaged public var entryDate: String?
    @NSManaged public var motive: String?
    @NSManaged public var observation: String?
    @NSManaged public var veterinarian: String?
    @NSManaged public var animal: Animal?

}
