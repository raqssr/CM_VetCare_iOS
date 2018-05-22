//
//  Procedure+CoreDataProperties.swift
//  VetCare
//
//  Created by Raquel Ramos on 22/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Procedure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Procedure> {
        return NSFetchRequest<Procedure>(entityName: "Procedure")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var animal: NSSet?

}

// MARK: Generated accessors for animal
extension Procedure {

    @objc(addAnimalObject:)
    @NSManaged public func addToAnimal(_ value: Animal)

    @objc(removeAnimalObject:)
    @NSManaged public func removeFromAnimal(_ value: Animal)

    @objc(addAnimal:)
    @NSManaged public func addToAnimal(_ values: NSSet)

    @objc(removeAnimal:)
    @NSManaged public func removeFromAnimal(_ values: NSSet)

}
