//
//  Fuel+CoreDataProperties.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 16/09/2024.
//
//

import Foundation
import CoreData


extension Fuel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fuel> {
        return NSFetchRequest<Fuel>(entityName: "Fuel")
    }

    @NSManaged public var fuelEconomy: String?
    @NSManaged public var filledDate: String?
    @NSManaged public var filledLiters: String?
    @NSManaged public var fuelAverageLkm: String?
    @NSManaged public var fuelStation: String?
    @NSManaged public var vehicle: Vehicle?

}

extension Fuel : Identifiable {

}
