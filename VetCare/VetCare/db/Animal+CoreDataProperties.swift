//
//  Animal+CoreDataProperties.swift
//  VetCare
//
//  Created by Raquel Ramos on 22/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Animal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Animal> {
        return NSFetchRequest<Animal>(entityName: "Animal")
    }

    @NSManaged public var breed: String?
    @NSManaged public var coat: String?
    @NSManaged public var dob: NSDate?
    @NSManaged public var gender: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var specie: String?
    @NSManaged public var weight: Double
    @NSManaged public var historic: NSSet?
    @NSManaged public var internment: Internment?
    @NSManaged public var medicine: NSSet?
    @NSManaged public var owner: Owner?
    @NSManaged public var procedure: NSSet?

}

// MARK: Generated accessors for historic
extension Animal {

    @objc(addHistoricObject:)
    @NSManaged public func addToHistoric(_ value: Historic)

    @objc(removeHistoricObject:)
    @NSManaged public func removeFromHistoric(_ value: Historic)

    @objc(addHistoric:)
    @NSManaged public func addToHistoric(_ values: NSSet)

    @objc(removeHistoric:)
    @NSManaged public func removeFromHistoric(_ values: NSSet)

}

// MARK: Generated accessors for medicine
extension Animal {

    @objc(addMedicineObject:)
    @NSManaged public func addToMedicine(_ value: Medicine)

    @objc(removeMedicineObject:)
    @NSManaged public func removeFromMedicine(_ value: Medicine)

    @objc(addMedicine:)
    @NSManaged public func addToMedicine(_ values: NSSet)

    @objc(removeMedicine:)
    @NSManaged public func removeFromMedicine(_ values: NSSet)

}

// MARK: Generated accessors for procedure
extension Animal {

    @objc(addProcedureObject:)
    @NSManaged public func addToProcedure(_ value: Procedure)

    @objc(removeProcedureObject:)
    @NSManaged public func removeFromProcedure(_ value: Procedure)

    @objc(addProcedure:)
    @NSManaged public func addToProcedure(_ values: NSSet)

    @objc(removeProcedure:)
    @NSManaged public func removeFromProcedure(_ values: NSSet)

}
