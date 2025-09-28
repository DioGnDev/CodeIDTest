//
//  PokemonRepository.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public protocol PokemonRepository {
  func fetchPokeList(next: String?) -> Observable<ItemModel>
  func fetchDetail(name: String) -> Observable<DetailEntity>
}
