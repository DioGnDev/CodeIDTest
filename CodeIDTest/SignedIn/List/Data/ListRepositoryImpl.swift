//
//  ListRepositoryImpl.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public class ListRepositoryImpl: ListRepository {
  
  private let remote: ListRemoteDataSource
  
  public init(remote: ListRemoteDataSource) {
    self.remote = remote
  }
  
  public func fetchPokeList() -> Single<ItemModel> {
    return remote.fetchPokemon()
  }
  
}
