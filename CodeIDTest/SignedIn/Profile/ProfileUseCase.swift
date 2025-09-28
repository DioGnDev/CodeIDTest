//
//  ProfileUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//

import RxSwift

public struct ProfileUseCase {
  
  private let userSessionRepo: UserSessionRepository
  
  public init(userSessionRepo: UserSessionRepository) {
    self.userSessionRepo = userSessionRepo
  }
  
  public func getMet() -> Single<UserSession?> {
    return userSessionRepo.readUsersession()
  }
  
  public func signOut() -> Completable {
    return userSessionRepo.deleteUserSession()
  }
}
