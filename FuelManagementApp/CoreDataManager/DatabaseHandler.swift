//
//  DatabaseHandler.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//

import UIKit

class DataBaseHandler {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     static func saveContext(){
        do {
            try context.save()
            print("Data saved Successfully")
        }
        catch {
            print("error in saving data")
        }
    }
    static func saveImage(_ image: UIImage, for vehicle: Vehicle) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            vehicle.vehicleImage = nil
            try? context.save()
            return
        }
        vehicle.vehicleImage = imageData
        do {
            try context.save()
            print("Image Saved Successfully")
        } catch {
            print("Error While Saving Image: \(error.localizedDescription)")
        }
    }
    static func getImage(_ vehicle: Vehicle) -> UIImage? {
        guard let imageData = vehicle.vehicleImage else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

