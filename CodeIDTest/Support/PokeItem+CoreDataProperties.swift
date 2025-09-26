//
//  PokeItem+CoreDataProperties.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//
//

import Foundation
import CoreData


extension PokeItem {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<PokeItem> {
    return NSFetchRequest<PokeItem>(entityName: "PokeItem")
  }
  
  @NSManaged public var id: UUID?
  @NSManaged public var name: String?
  @NSManaged public var url: String?
  
}

extension PokeItem : Identifiable {
  
}
