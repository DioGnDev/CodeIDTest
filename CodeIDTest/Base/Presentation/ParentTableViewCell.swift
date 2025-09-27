//
//  ParentTableViewCell.swift
//
//
//  Created by Ilham Hadi P. on 12/05/22.
//

import UIKit

protocol CellAnimateable {
  func showAnimation()
  func hideAnimation()
}

open class ParentTableViewCell: UITableViewCell {
  
  public var viewModel: TableItemModel?
  
  public init(){
    self.viewModel = nil
    super.init(style: .default, reuseIdentifier: nil)
    setupView()
  }
  
  public init(_ viewModel: TableItemModel){
    self.viewModel = viewModel
    super.init(style: .default, reuseIdentifier: nil)
    setupView()
  }
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.viewModel = nil
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setViewModel(_ viewModel: TableItemModel){
    self.viewModel = viewModel
    setupView()
  }
  
  open func setupViewWithData(){
    guard let _ = viewModel else {
      return
    }
  }
  
  open func setupView(){
    setupViewWithData()
  }
  
}

open class ParentTableViewCellAnimateable: ParentTableViewCell, CellAnimateable {
  open func showAnimation() { }
  open func hideAnimation() { }
}
