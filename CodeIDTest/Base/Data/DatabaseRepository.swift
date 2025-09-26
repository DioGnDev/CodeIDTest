//
//  DatabaseRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import CoreData
import RxSwift

public protocol DatabaseRepository {
  func savePokeItem(items: [PokeItem]) -> Single<Bool>
  func fetchCachedUsers()
  func isCacheValid()
}

public struct DatabaseRepositoryImpl: DatabaseRepository {
  
  private let context: NSManagedObjectContext
  
  public init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  public func savePokeItem(items: [PokeItem]) -> Single<Bool> {
    return .just(true)
  }
  
  public func fetchCachedUsers() {
    
  }
  
  public func isCacheValid() {
    
  }
  
}
