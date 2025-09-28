//
//  DetailModel.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//

import Foundation

public struct DetailModel: Codable {
  let abilities: [Ability]
  
  enum CodingKeys: String, CodingKey {
    case abilities
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.abilities = try container.decode([Ability].self, forKey: .abilities)
  }
}

public struct Ability: Codable {
  let ability: Species?
  
  enum CodingKeys: String, CodingKey {
    case ability
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.ability = try container.decodeIfPresent(Species.self, forKey: .ability)
  }
}

public struct Species: Codable {
  let name: String?
  let url: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case url
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.url = try container.decodeIfPresent(String.self, forKey: .url)
  }
}
