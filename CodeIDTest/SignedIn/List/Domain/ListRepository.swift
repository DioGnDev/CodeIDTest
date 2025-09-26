//
//  ListRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public protocol ListRepository {
  func fetchPokeList() -> Single<[PokeItem]>
}
