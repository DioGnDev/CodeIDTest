//
//  ItemModel.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation

public struct ItemModel: Codable {
  public let count: Int
  public let next: String
  public let previous: String?
  public let results: [ItemDataModel]
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.count = try container.decode(Int.self, forKey: .count)
    self.next = try container.decode(String.self, forKey: .next)
    self.previous = try container.decodeIfPresent(String.self, forKey: .previous)
    self.results = try container.decode([ItemDataModel].self, forKey: .results)
  }
}

public struct ItemDataModel: Codable {
  public let name: String
  public let url: String
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(String.self, forKey: .url)
  }
}
