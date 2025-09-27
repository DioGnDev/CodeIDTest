//
//  ListUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public class ListUseCase {
  
  let repository: ListRepository
  let cache: CachedRepository
  
  private var disposeBag = DisposeBag()
  
  public init(
    repository: ListRepository,
    cache: CachedRepository
  ) {
    self.repository = repository
    self.cache = cache
  }
  
  public func loadItems() -> Single<[PokeItem]> {
    return cache.fetchCachedItems()
      .flatMap(handleCachedValidation(_:))
  }
  
  private func handleCachedValidation(_ cached: [PokeItem]) -> Single<[PokeItem]> {
    return cache.isCacheValid(cached)
      .flatMap { [weak self] isValid -> Single<[PokeItem]> in
        guard let self = self else { return .just([]) }
        if isValid, !cached.isEmpty {
          return .just(cached)
        } else {
          return self.fetchAndCachedFromAPI()
        }
      }
  }
  
  private func fetchAndCachedFromAPI() -> Single<[PokeItem]>{
    return repository
      .fetchPokeList()
      .flatMap { [weak self] item in
        guard let self = self else { return .just([]) }
        self.cache.save(items: item.results)
        return self.cache.fetchCachedItems()
      }
  }
  
}
