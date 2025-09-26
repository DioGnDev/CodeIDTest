//
//  ListUseCase.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public struct ListUseCase {
  
  let listRepository: ListRepository
  let dbRepository: DatabaseRepository
  
  private var disposeBag = DisposeBag()
  
  public init(
    listRepository: ListRepository,
    dbRepository: DatabaseRepository
  ) {
    self.listRepository = listRepository
    self.dbRepository = dbRepository
  }
  
  func fetchFromAPI() {
    listRepository
      .fetchPokeList()
      .flatMap { dbRepository.savePokeItem(items: $0) }
      .subscribe { state in
        
      } onFailure: { error in
        
      }
      .disposed(by: disposeBag)
  }
  
  
}
