//
//  LoginUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public class LoginUseCase {
  
  private let userSessionRepository: UserSessionRepository
  private let loginRepository: LoginRepository
  
  public init(
    userSessionRepository: UserSessionRepository,
    loginRepository: LoginRepository
  ) {
    self.userSessionRepository = userSessionRepository
    self.loginRepository = loginRepository
  }
  
  public func login() {
    
  }
  
}
