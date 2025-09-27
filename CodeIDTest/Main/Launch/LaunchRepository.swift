//
//  LaunchRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation
import RxSwift

public struct LaunchRepositoryImpl: IsSignedInRepository {
  
  let remote: AuthDataSource
  
  public init(remote: AuthDataSource) {
    self.remote = remote
  }
  
  public func checkIsLogin() -> Single<Bool> {
    return remote.fetch()
  }
  
}
