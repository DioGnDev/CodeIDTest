//
//  ListRepositoryImpl.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public class PokemonRepositoryImpl: PokemonRepository  {
  
  private let remote: PokemonRemoteDataSource
  
  public init(remote: PokemonRemoteDataSource) {
    self.remote = remote
  }
  
  public func fetchPokeList(next: String?) -> Observable<ItemModel> {
    return remote.fetchPokemon(next: next)
  }
  
  public func fetchDetail(name: String) -> Observable<DetailEntity> {
    return remote.fetchDetail(param: name)
      .map { model in
        return DetailEntity(
          name: name,
          abillities: model.abilities.map{ $0.ability?.name ?? ""}
        )
      }
  }
  
}
