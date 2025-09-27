//
//  ListUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import RxSwift

public class ListUseCase {
  
  let repository: ListRepository
  let cache: CachedRepository
  
  var pagination: PaginationModel!
  
  private var disposeBag = DisposeBag()
  
  public init(
    repository: ListRepository,
    cache: CachedRepository
  ) {
    self.repository = repository
    self.cache = cache
  }
  
  public func loadItems() -> Observable<[PokeEntity]> {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
    
    return Reachability.shared.isOnline
      .take(1)
      .flatMapLatest { isOnline -> Observable<[PokeEntity]> in
        if isOnline {
          return self.repository.fetchPokeList(next: nil)
            .do(onNext: { [weak self] model in
              self?.pagination = PaginationModel(count: model.count, next: model.next)
              self?.cache.save(items: model.results)
            })
            .map { $0.results.map { item in
              PokeEntity(id: UUID(), name: item.name)
            }}
            .asObservable()
          
        } else {
          return Observable.deferred {
            return self.cache.fetchCachedItems()
          }
        }
      }
      .subscribe(on: scheduler)
      .observe(on: MainScheduler.instance)
    
  }
  
  public func loadMore() -> Observable<[PokeEntity]> {
    return repository
      .fetchPokeList(next: pagination.next)
      .do(onNext: { [weak self] model in
        self?.pagination = PaginationModel(count: model.count, next: model.next)
      })
      .map { $0.results.map { item in
        PokeEntity(id: UUID(), name: item.name)
      }}
      .asObservable()
  }
  
  //  private func handleCachedValidation(_ cached: [PokeItem]) -> Single<[PokeItem]> {
  //    return cache.isCacheValid(cached)
  //      .flatMap { [weak self] isValid -> Single<[PokeItem]> in
  //        guard let self = self else { return .just([]) }
  //        if isValid, !cached.isEmpty {
  //          return .just(cached)
  //        } else {
  //          return self.fetchAndCachedFromAPI()
  //        }
  //      }
  //  }
  
  //  private func fetchAndCachedFromAPI() -> Single<[PokeItem]>{
  //    return repository
  //      .fetchPokeList(next: nil)
  //      .flatMap { [weak self] item in
  //        self?.pagination = PaginationModel(
  //          count: item.count,
  //          next: item.next
  //        )
  //
  //        guard let self = self else { return .just([]) }
  //        self.cache.save(items: item.results)
  //        return self.cache.fetchCachedItems()
  //      }
  //  }
  
}
