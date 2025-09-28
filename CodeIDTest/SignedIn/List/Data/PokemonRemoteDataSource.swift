//
//  ListRemoteDataSource.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import RxSwift

public protocol PokemonRemoteDataSource {
  func fetchPokemon(next: String?) -> Observable<ItemModel>
  func fetchDetail(param: String) -> Observable<DetailModel>
}

public struct PokemonRemoteDataSourceImpl: PokemonRemoteDataSource {
  
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
  
  public func fetchDetail(param: String) -> Observable<DetailModel> {
    return self.service.request(
      of: DetailModel.self,
      with: Endpoint.POKEMON_DETAIL.appending(param),
      withMethod: .get,
      withHeaders: [:],
      withParameter: [:],
      withEncoding: .url
    )
  }
  
}
