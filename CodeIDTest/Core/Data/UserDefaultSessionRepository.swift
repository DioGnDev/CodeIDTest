//
//  UserDefaultSessionRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public struct UserDefaultSessionRepository: UserSessionRepository {
  
  private let userDefaults = UserDefaults.standard
  private let sessionKey = "user_session_key"
  
  public func readUsersession() -> Single<UserSession?> {
    return Single.create { single in
      if let data = userDefaults.data(forKey: sessionKey),
         let session = try? JSONDecoder().decode(UserSession.self, from: data) {
        single(.success(session))
      } else {
        single(.success(nil))
      }
      return Disposables.create()
    }
  }
  
  public func save(userSession: UserSession) -> Single<UserSession?> {
    return Single.create { single in
      do {
        let data = try JSONEncoder().encode(userSession)
        userDefaults.set(data, forKey: sessionKey)
        single(.success(userSession))
      } catch {
        single(.failure(error))
      }
      return Disposables.create()
    }
  }
  
  public func deleteUserSession() -> Completable {
    return Completable.create { completable in
      userDefaults.removeObject(forKey: sessionKey)
      completable(.completed)
      return Disposables.create()
    }
  }
  
}
