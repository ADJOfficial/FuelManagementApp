//
//  FuelModel.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 09/09/2024.
//

import CoreData

struct FuelModel {
    var objectID: NSManagedObjectID
    var fuelStation: String
    var filledDate: Date
    var filledLiters: String
    var fuelEconomy: String
    var fuelAverageLkm: String
}
