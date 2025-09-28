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
    return repo.fetchDetail(name: name)
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
      .observe(on: MainScheduler.instance)
  }
  
}
