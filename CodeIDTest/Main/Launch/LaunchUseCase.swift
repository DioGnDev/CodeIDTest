//
//  LaunchUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public class LaunchUseCase {
  
  private let repo: IsSignedInRepository
  
  private var disposeBag = DisposeBag()
  
  public init(repo: IsSignedInRepository) {
    self.repo = repo
  }
  
  public func loadUserSession() -> Single<Bool> {
    return repo.checkIsLogin()
  }
  
}
