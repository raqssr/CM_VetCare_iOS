//
//  Medicine+CoreDataProperties.swift
//  VetCare
//
//  Created by Raquel Ramos on 22/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var dosage: Double
    @NSManaged public var frequency: Int16
    @NSManaged public var name: String?
    @NSManaged public var totalDays: Int16
    @NSManaged public var animal: NSSet?

}

// MARK: Generated accessors for animal
extension Medicine {

    @objc(addAnimalObject:)
    @NSManaged public func addToAnimal(_ value: Animal)

    @objc(removeAnimalObject:)
    @NSManaged public func removeFromAnimal(_ value: Animal)

    @objc(addAnimal:)
    @NSManaged public func addToAnimal(_ values: NSSet)

    @objc(removeAnimal:)
    @NSManaged public func removeFromAnimal(_ values: NSSet)

}
