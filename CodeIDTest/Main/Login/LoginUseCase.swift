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
  private let navigator: AppNavigator
  
  private var disposeBag = DisposeBag()
  
  public init(
    userSessionRepository: UserSessionRepository,
    navigator: AppNavigator
  ) {
    self.userSessionRepository = userSessionRepository
    self.navigator = navigator
  }
  
  public func login(name: String, email: String) {
    userSessionRepository
      .save(userSession: UserSession(name: name, email: email))
      .map { $0! }
      .subscribe { [weak self] userSession in
        self?.navigator.navigateToSignedIn(userSession)
      } onFailure: { error in
        
      }.disposed(by: disposeBag)
    
  }
  
}
