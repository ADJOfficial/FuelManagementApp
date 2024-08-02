//
//  DatabaseHandler.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//

import Foundation
import UIKit
class DataBaseHandler {
    //MARK: -Variables
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: -Functions
     static func saveDataInCoreData(){
        do {
            try context.save()
            print("Data saved Successfully")
        }
        catch {
            print("error in saving data")
        }
    }
}
