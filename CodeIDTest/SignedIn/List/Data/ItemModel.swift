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
  public let previous: JSONNull?
  public let results: [ItemDataModel]
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.count = try container.decode(Int.self, forKey: .count)
    self.next = try container.decode(String.self, forKey: .next)
    self.previous = try container.decodeIfPresent(JSONNull.self, forKey: .previous)
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

// MARK: Encode/decode helpers

public class JSONNull: Codable, Hashable {
  
  public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
    return true
  }
  
  public func hash(into hasher: inout Hasher) {
    return hasher.combine(0)
  }
  
  public init() {}
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}
