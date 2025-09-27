//
//  RegisterUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public class RegisterUseCase {
  
  private let authRepo: AuthRepository
  
  public init(authRepo: AuthRepository) {
    self.authRepo = authRepo
  }
  
  func register(username: String, password: String) -> Single<Bool> {
    authRepo.signUp(username: username, password: password)
  }
  
}
