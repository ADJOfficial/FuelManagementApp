//
//  Vehicle.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 09/09/2024.
//

import CoreData

struct VehicleModel {
    var objectID: NSManagedObjectID = NSManagedObjectID()
    var vehicleName: String = ""
    var vehicleImage: Data = Data()
    var vehicleCostLkm: String = ""
    var purchaseDate: String = ""
    var fuelPrice: Int = 0
    var maintenanceCost: String = ""
    var repairCost: String = ""
}
