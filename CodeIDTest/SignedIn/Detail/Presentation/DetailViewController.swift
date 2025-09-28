//
//  DetailViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift

public class DetailViewController: NiblessViewController {
  
  //Dependency
  private let useCase: DetailUseCase
  private let name: String
  
  //property
  
  //state
  private var disposeBag = DisposeBag()
  
  //View
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 24)
    label.textColor = UIColor.black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let stackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    sv.spacing = 16
    sv.alignment = .fill
    sv.distribution = .fill
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()
  
  public init(name: String, useCase: DetailUseCase) {
    self.name = name
    self.useCase = useCase
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .white
    
    standardNavBar(title: "Poke Detail")
    setupView()
    loadData()
  }
  
  func setupView() {
    view.addSubview(nameLabel)
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  func loadData() {
    useCase.fetchData(name: name)
      .subscribe(
        onNext: { [weak self] entity in
          guard let self = self else { return }
          nameLabel.text = name
          for i in 0..<entity.abillities.count {
            stackView.addArrangedSubview(
              createAbillity(
                id: i + 1,
                name: entity.abillities[i]
              )
            )
          }
        }
      )
      .disposed(by: disposeBag)
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
  private func createAbillity(id: Int, name: String) -> UILabel {
    let label = UILabel()
    label.text = name
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .black
    return label
  }
  
}

