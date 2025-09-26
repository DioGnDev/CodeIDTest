//
//  UserSessionRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public protocol UserSessionRepository {
  
  func readUsersession() -> Single<UserSession?>
  
  func save(userSession: UserSession) -> Single<UserSession?>
  
  func deleteUserSession() -> Completable
  
}

public protocol UserSessionRepositoryFactory {
  func makeUserSessionRepository() -> UserSessionRepository
}
