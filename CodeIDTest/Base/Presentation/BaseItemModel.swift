//
//  BaseItemModel.swift
//  ListView
//
//  Created by Ilham Hadi Prabawa on 09/04/22.
//

import Foundation

open class BaseItemModel: Equatable, Hashable {
  
  public let id: String
  
  public init(id: String){
    self.id = id
  }
  
  open func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public static func == (lhs: BaseItemModel, rhs: BaseItemModel) -> Bool {
    return lhs.id == rhs.id
  }
}
