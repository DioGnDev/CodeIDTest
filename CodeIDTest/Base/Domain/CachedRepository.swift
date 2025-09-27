//
//  CachedRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import RxSwift

public protocol CachedRepository {
  func save(items: [ItemDataModel])
  func fetchCachedItems() -> Single<[PokeItem]>
  func isCacheValid(_ cached: [PokeItem]) -> Single<Bool>
}
