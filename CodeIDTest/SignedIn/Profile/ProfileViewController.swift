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
    label.font = .boldSystemFont(ofSize: 24)
    label.textColor = UIColor.black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 16)
    label.textColor = UIColor.systemBlue
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
    
    view.backgroundColor = .yellow
    
    setupView()
    loadData()
    
  }
  
  fileprivate func setupView() {
    view.addSubview(nameLabel)
    view.addSubview(signOutButton)
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
      nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      signOutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
      signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -16),
      signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
    
    signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    
  }
  
  fileprivate func loadData() {
    useCase.getMet()
      .compactMap { $0! }
      .subscribe(onSuccess: { [weak self] session in
        self?.nameLabel.text = session.name
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
