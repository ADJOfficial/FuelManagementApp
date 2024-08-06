//
//  Vehicle+CoreDataProperties.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 06/08/2024.
//
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var vehicleName: String?
    @NSManaged public var vehicleMake: String?
    @NSManaged public var vehicleModel: String?
    @NSManaged public var vehicleYear: String?
    @NSManaged public var vehicleFuelType: String?

}

extension Vehicle : Identifiable {

}
