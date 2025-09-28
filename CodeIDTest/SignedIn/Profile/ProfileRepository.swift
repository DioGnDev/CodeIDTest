//
//  ProfileRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//

import RxSwift

public protocol ProfileRepository {
  func getMe() -> Single<User?>
}
