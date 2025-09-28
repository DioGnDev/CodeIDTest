//
//  DetailViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift
import MBProgressHUD

public class DetailViewController: NiblessViewController {
  
  //Dependency
  private let useCase: DetailUseCase
  private let name: String
  
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
  
  private let abilityLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 16)
    label.textColor = UIColor.systemBlue
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
    view.addSubview(abilityLabel)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      abilityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
      abilityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      abilityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      stackView.topAnchor.constraint(equalTo: abilityLabel.bottomAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: abilityLabel.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  func loadData() {
    showLoading()
    useCase.fetchData(name: name)
      .subscribe(
        onNext: { entity in
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            nameLabel.text = name
            abilityLabel.text = "Ability:"
            for i in 0..<entity.abillities.count {
              stackView.addArrangedSubview(
                createAbillity(
                  id: i + 1,
                  name: entity.abillities[i]
                )
              )
            }
            
            self.hideLoading()
          }
        },
        onError: { [weak self] error in
          guard let self = self,
                  let error = error as? ErrorMessage
          else { return }
          
          showErrorAlert(title: error.title, msg: error.message)
          hideLoading()
        }
      )
      .disposed(by: disposeBag)
  }
  
  fileprivate func showLoading() {
    let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    progressHUD.mode = .indeterminate
    progressHUD.label.text = "Loading"
  }
  
  fileprivate func hideLoading() {
    MBProgressHUD.hide(for: self.view, animated: true)
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

