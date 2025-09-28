//
//  User+CoreDataProperties.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var password: String?
    @NSManaged public var signedIn: Bool
    @NSManaged public var username: String?
    @NSManaged public var email: String?

}

extension User : Identifiable {

}
