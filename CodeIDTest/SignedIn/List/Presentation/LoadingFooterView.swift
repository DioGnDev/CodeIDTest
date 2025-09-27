//
//  LoadingFooterView.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//

import UIKit

class LoadingFooterView: UIView {
  let activityIndicator = UIActivityIndicatorView(style: .medium)
  let loadingLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  private func setupViews() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    loadingLabel.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(activityIndicator)
    addSubview(loadingLabel)
    
    loadingLabel.text = "Loading..."
    loadingLabel.textColor = .gray
    loadingLabel.font = UIFont.systemFont(ofSize: 14)
    
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10), // Adjust as needed
      loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 5)
    ])
  }
  
  func startLoading() {
    activityIndicator.startAnimating()
    isHidden = false
  }
  
  func stopLoading() {
    activityIndicator.stopAnimating()
    isHidden = true
  }
}
