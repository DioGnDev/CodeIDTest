//
//  CoreDataUserSessionRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//

import RxSwift
import CoreData

public struct CoreDataUserSession: UserSessionRepository {
  
  private let context: NSManagedObjectContext
  
  public init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  // MARK: - Public
  
  public func readUsersession() -> Single<UserSession?> {
    return Single.create { observer in
      context.perform {
        do {
          let request: NSFetchRequest<User> = User.fetchRequest()
          if let user = try context.fetch(request).first {
            let session = UserSession(
              name: user.username ?? "",
              email: user.email ?? ""
            )
            observer(.success(session))
          } else {
            observer(.failure(ErrorMessage(title: "Error", message: "Couldn't fetch data")))
          }
        } catch {
          observer(.failure(ErrorMessage(title: "Error", message: error.localizedDescription)))
        }
      }
      return Disposables.create()
    }
  }
  
  public func save(userSession: UserSession) -> Single<UserSession?> {
    fatalError("not implemented yet")
  }
  
  public func deleteUserSession() -> Completable {
    return Completable.create { completable in
      context.perform {
        do {
          let req: NSFetchRequest<User> = User.fetchRequest()
          let all = try context.fetch(req)
          all.forEach { context.delete($0) }
          try context.save()
          completable(.completed)
        } catch {
          context.rollback()
          completable(.error(error))
        }
      }
      return Disposables.create()
    }
  }
  
}

