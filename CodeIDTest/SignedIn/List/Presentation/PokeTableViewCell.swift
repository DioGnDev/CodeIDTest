//
//  PokeTableViewCell.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import UIKit

public final class PokeTableViewCell: ParentTableViewCell {
  
  public static let identifier = "PokeTableViewCell"
  
  private let label: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()
  
  public override func setupView() {
    super.setupView()
    
    contentView.addSubview(label)
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
    ])
  }
  
  public override func setupViewWithData() {
    super.setupViewWithData()
    
    guard let model = viewModel as? PokeTableItemModel else { return }
    label.text = model.name
  }
}
