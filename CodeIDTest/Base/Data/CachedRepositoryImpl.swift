//
//  DatabaseRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import CoreData
import RxSwift

public class CachedRepositoryImpl: CachedRepository {
  
  private let context: NSManagedObjectContext
  private let expiry: TimeInterval
  
  public init(
    context: NSManagedObjectContext,
    expiry: TimeInterval = 3600
  ) {
    self.context = context
    self.expiry = expiry
  }
  
  public func save(items: [ItemDataModel]) {
    do {
      let fetch: NSFetchRequest<NSFetchRequestResult> = PokeItem.fetchRequest()
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
      deleteRequest.resultType = .resultTypeObjectIDs
      
      if let result = try context.execute(deleteRequest) as? NSBatchDeleteResult,
         let deletedIDs = result.result as? [NSManagedObjectID],
         !deletedIDs.isEmpty {
        
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: deletedIDs]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
      } else {
        context.reset()
      }
      
      for item in items {
        let entity = PokeItem(context: context)
        entity.id = UUID()
        entity.name = item.name
        entity.lastUpdatedAt = Date()
      }
      
      if context.hasChanges {
        try context.save()
      }
      
    } catch {
      
    }
  }
  
  public func update(items: [ItemDataModel]) {
    for item in items {
      let entity = PokeItem(context: context)
      entity.id = UUID()
      entity.name = item.name
      entity.lastUpdatedAt = Date()
      
      if context.hasChanges {
        try? context.save()
      }
    }
  }
  
  public func fetchCachedItems() -> Observable<[PokeEntity]> {
    return Observable.create { observer in
      let request: NSFetchRequest<PokeItem> = PokeItem.fetchRequest()
      do {
        let result = try self.context.fetch(request)
        let entity = result.map { PokeEntity(id: $0.id ?? UUID(), name: $0.name ?? "") }
        observer.onNext(entity)
      } catch {
        observer.onError(ErrorMessage(title: "error", message: "no data found"))
      }
      
      return Disposables.create()
    }
  }
  
  public func isCacheValid(_ cached: [PokeItem]) -> Single<Bool> {
    return Single.create { single in
      guard let last = cached.first?.lastUpdatedAt else {
        single(.success(false))
        return Disposables.create()
      }
      
      let valid = Date().timeIntervalSince(last) < self.expiry
      single(.success(valid))
      return Disposables.create()
    }
  }
  
}
