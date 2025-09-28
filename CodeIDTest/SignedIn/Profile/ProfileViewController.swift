//
//  ProfileViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import UIKit
import XLPagerTabStrip
import RxSwift

public class ProfileViewController: NiblessViewController, IndicatorInfoProvider {
  
  private let useCase: ProfileUseCase
  private let responder: LoginResponder
  
  private let disposeBag = DisposeBag()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let signOutButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Out", for: .normal)
    button.layer.cornerRadius = 8
    button.isEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
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
  
  public init(
    useCase: ProfileUseCase,
    responder: LoginResponder
  ) {
    self.useCase = useCase
    self.responder = responder
    super.init()
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .white
    
    setupView()
    loadData()
    
  }
  
  fileprivate func setupView() {
    
    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(emailLabel)
    stackView.addArrangedSubview(signOutButton)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
    
    signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    
  }
  
  fileprivate func loadData() {
    useCase.getMet()
      .compactMap { $0! }
      .subscribe(onSuccess: { [weak self] session in
        self?.nameLabel.text = String(format: "Name: %@", session.name)
        self?.emailLabel.text = String(format: "Email: %@", session.email)
      })
      .disposed(by: disposeBag)
  }
  
  public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return "Profile"
  }
  
  @objc func signOut() {
    useCase.signOut()
      .subscribe { [weak self] _ in
        self?.responder.gotoLogin()
      }
      .disposed(by: disposeBag)
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
