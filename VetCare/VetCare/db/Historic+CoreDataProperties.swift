//
//  Historic+CoreDataProperties.swift
//  VetCare
//
//  Created by Raquel Ramos on 22/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Historic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Historic> {
        return NSFetchRequest<Historic>(entityName: "Historic")
    }

    @NSManaged public var dates: NSDate?
    @NSManaged public var procedures: String?
    @NSManaged public var animal: Animal?

}
