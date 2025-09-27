//
//  AuthRepositoryImpl.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation
import RxSwift

public class AuthRepositoryImpl: AuthRepository, IsSignedInRepository {
  
  private let dataSource: AuthDataSource
  
  public init(dataSource: AuthDataSource) {
    self.dataSource = dataSource
  }
  
  public func checkIsLogin() -> Single<Bool> {
    dataSource.fetch()
  }
  
  public func signIn(username: String, password: String) -> Single<Bool> {
    dataSource.signIn(username: username, password: password)
  }
  
  public func signOut() -> Single<Bool> {
    dataSource.signOut()
  }
  
  public func signUp(username: String, password: String) -> Single<Bool> {
    dataSource.signUp(username: username, password: password)
  }
  
}

