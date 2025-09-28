//
//  DetailUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//

import RxSwift

public class DetailUseCase {
  
  let repo: PokemonRepository
  
  public init(repo: PokemonRepository) {
    self.repo = repo
  }
  
  public func fetchData(name: String) -> Observable<DetailEntity>{
    return Reachability.shared.isOnline
      .take(1)
      .flatMapLatest { [weak self] isOnline -> Observable<DetailEntity> in
        guard let self = self else {
          return .error(ErrorMessage(title: "Error", message: "Unknown Error"))
        }
        if isOnline {
          return repo.fetchDetail(name: name)
        } else {
          return .error(ErrorMessage(title: "Error", message: "Please check your connection"))
        }
      }
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
      .observe(on: MainScheduler.instance)
  }
  
}
