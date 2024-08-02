//
//  User+CoreDataProperties.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var username: String?

}

extension User : Identifiable {

}
