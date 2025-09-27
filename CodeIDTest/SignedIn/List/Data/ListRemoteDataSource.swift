//
//  ListRemoteDataSource.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import RxSwift

public protocol ListRemoteDataSource {
  func fetchPokemon() -> Single<ItemModel>
}

public struct ListRemoteDataSourceImpl: ListRemoteDataSource {
  
  let service: Service
  
  public func fetchPokemon() -> Single<ItemModel> {
    return self.service.request(
      of: ItemModel.self,
      with: Endpoint.POKEMON,
      withMethod: .get,
      withHeaders: [:],
      withParameter: [:],
      withEncoding: .url
    )
  }
}
