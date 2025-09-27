//
//  LoginLocalDataSource.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation
import RxSwift
import CoreData

public protocol AuthDataSource {
  func fetch() -> Single<Bool>
  func signIn(username: String, password: String) -> Single<Bool>
  func signUp(username: String, password: String) -> Single<Bool>
  func signOut() -> Single<Bool>
}

public final class AuthLocalDataSourceImpl: AuthDataSource {
  
  private let context: NSManagedObjectContext
  
  public init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  public func fetch() -> Single<Bool> {
    Single.create { [weak self] observer in
      guard let self else { return Disposables.create() }
      self.context.perform {
        do {
          let session = try self.fetchOrNil()
          observer(.success(session?.signedIn ?? false))
        } catch {
          observer(.failure(error))
        }
      }
      return Disposables.create()
    }
  }
  
  public func signIn(username: String, password: String) -> Single<Bool> {
    Single.create { [weak self] observer in
      print("login mantab")
      
      do {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let users = try self?.context.fetch(request)
        
        if let user = users?.first,
           user.username == username && user.password == password {
          observer(.success(user.signedIn))
        } else {
          observer(.failure(ErrorMessage(title: "Error", message: "please register first")))
        }
      } catch {
        observer(.failure(error))
      }
      return Disposables.create()
    }
  }
  
  public func signOut() -> Single<Bool> {
    Single.create { [weak self] observer in
      guard let self else { return Disposables.create() }
      self.context.perform {
        do {
          if let session = try self.fetchOrNil() {
            session.signedIn = false
            try self.saveIfNeeded()
          }
          observer(.success(true))
        } catch {
          observer(.failure(error))
        }
      }
      return Disposables.create()
    }
  }
  
  public func signUp(username: String, password: String) -> Single<Bool> {
    Single.create { [weak self] single in
      guard let self = self else { return Disposables.create() }
      self.context.perform {
        do {
          let session = User(context: self.context)
          session.id = UUID()
          session.username = username
          session.password = password
          session.signedIn = true
          try self.saveIfNeeded()
          single(.success(true))
        } catch {
          single(.failure(ErrorMessage(title: "error", message: "Error")))
        }
      }
      
      return Disposables.create()
    }
  }
  
}

private extension AuthLocalDataSourceImpl {
  
  func fetchOrNil() throws -> User? {
    let req = User.fetchRequest()
    req.fetchLimit = 1
    return try context.fetch(req).first
  }
  
  func saveIfNeeded() throws {
    if context.hasChanges { try context.save() }
  }
  
}
