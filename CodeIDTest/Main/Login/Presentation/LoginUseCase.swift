//
//  LoginUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public class LoginUseCase {
  
  private let authRepo: AuthRepository
  private var disposeBag = DisposeBag()
  
  public init(authRepo: AuthRepository) {
    self.authRepo = authRepo
  }
  
  public func login(username: String, password: String) -> Single<Bool> {
    authRepo.signIn(username: username, password: password)
  }
  
}
