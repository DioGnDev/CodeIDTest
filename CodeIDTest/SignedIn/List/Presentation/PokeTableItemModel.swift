//
//  PokeItemModel.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import UIKit

public final class PokeTableItemModel: TableItemModel {

  let name: String
  
  init(
    id: String,
    type: UITableViewCell.Type,
    identifier: String,
    name: String
  ) {
    self.name = name
    
    super.init(
      id: id,
      type: type,
      identifier: identifier
    )
  }
  
}
