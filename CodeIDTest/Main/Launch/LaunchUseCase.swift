//
//  LaunchUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public class LaunchUseCase {
  
  private let userSessionRepository: UserSessionRepository
  public let presentLogin = PublishSubject<ErrorMessage>()
  public let navigateToList = PublishSubject<UserSession>()
  
  private var disposeBag = DisposeBag()
  
  public init(userSessionRepository: UserSessionRepository) {
    self.userSessionRepository = userSessionRepository
  }
  
  public func loadUserSession() {
    userSessionRepository
      .readUsersession()
      .observe(on: MainScheduler.instance)
      .map { $0! }
      .subscribe { [weak self] session in
        self?.navigateToList.onNext(session)
      } onFailure: { [weak self] error in
        guard let error = error as? ErrorMessage else { return }
        self?.presentLogin.onNext(error)
      }
      .disposed(by: disposeBag)
  }
  
}
