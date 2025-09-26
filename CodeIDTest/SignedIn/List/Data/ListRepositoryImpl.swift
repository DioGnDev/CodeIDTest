//
//  ListRepositoryImpl.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public class ListRepositoryImpl: ListRepository {
  
  public func fetchPokeList() -> Single<[PokeItem]> {
    return Single.create { single in
      return Disposables.create()
    }
  }
  
}
