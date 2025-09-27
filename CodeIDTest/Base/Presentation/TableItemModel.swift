//
//  TableItemModel.swift
//
//
//  Created by Ilham Hadi P. on 12/05/22.
//

import Foundation
import UIKit

open class TableItemModel: BaseItemModel {
  
  public var type: UITableViewCell.Type
  public var identifier: String
  
  public init(
    id: String,
    type: UITableViewCell.Type,
    identifier: String
  ) {
    self.type = type
    self.identifier = identifier
    
    super.init(id: id)
  }
  
  public override func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  public static func == (lhs: TableItemModel, rhs: TableItemModel) -> Bool {
    return lhs.identifier == rhs.identifier
  }
  
}
