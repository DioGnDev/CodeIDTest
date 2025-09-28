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
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
    return Reachability.shared.isOnline
      .take(1)
      .flatMapLatest { [weak self] isOnline -> Observable<[PokeEntity]> in
        guard let self = self else { return .just([])}
        if isOnline && pagination.next != nil {
          return repository
            .fetchPokeList(next: pagination.next)
            .do(onNext: { [weak self] model in
              self?.pagination = PaginationModel(count: model.count, next: model.next)
            })
            .map { $0.results.map { item in
              PokeEntity(id: UUID(), name: item.name)
            }}
            .asObservable()
        } else {
          return .just([])
        }
      }
      .subscribe(on: scheduler)
      .observe(on: MainScheduler.instance)
    
  }
  
}
