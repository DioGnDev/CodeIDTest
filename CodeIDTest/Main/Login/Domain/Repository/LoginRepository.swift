//
//  LoginRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation
import RxSwift

public protocol AuthRepository {
  func signIn(
    username: String,
    password: String
  ) -> Single<Bool>
  
  func signUp(
    username: String,
    email: String,
    password: String
  ) -> Single<Bool>
  
  func signOut() -> Single<Bool>
}

public protocol IsSignedInRepository {
  func checkIsLogin() -> Single<Bool>
}
