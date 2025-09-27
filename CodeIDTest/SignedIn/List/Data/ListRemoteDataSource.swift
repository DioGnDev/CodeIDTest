//
//  ListRemoteDataSource.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import RxSwift

public protocol ListRemoteDataSource {
  func fetchPokemon(next: String?) -> Observable<ItemModel>
}

public struct ListRemoteDataSourceImpl: ListRemoteDataSource {
  
  let service: Service
  
  public func fetchPokemon(next: String?) -> Observable<ItemModel> {
    return self.service.request(
      of: ItemModel.self,
      with: next ?? Endpoint.POKEMON,
      withMethod: .get,
      withHeaders: [:],
      withParameter: [:],
      withEncoding: .url
    )
  }
}
