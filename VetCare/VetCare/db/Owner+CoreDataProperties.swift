//
//  Owner+CoreDataProperties.swift
//  VetCare
//
//  Created by Raquel Ramos on 22/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Owner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Owner> {
        return NSFetchRequest<Owner>(entityName: "Owner")
    }

    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: Int32
    @NSManaged public var animal: Animal?

}
