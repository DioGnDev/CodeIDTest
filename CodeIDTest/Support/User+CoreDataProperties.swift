//
//  User+CoreDataProperties.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String
    @NSManaged public var password: String
    @NSManaged public var id: UUID
    @NSManaged public var signedIn: Bool

}

extension User : Identifiable {

}
