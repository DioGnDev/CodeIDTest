//
//  LoginViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

public class LoginViewController: NiblessViewController {
  
  private let useCase: LoginUseCase
  private let navigator: AppNavigator
  
  private var disposeBag = DisposeBag()
  
  private let label: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.text = "Login"
    return lbl
  }()
  
  private let usernameField: UITextField = {
    let tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.autocapitalizationType = .none
    tf.tag = 0
    tf.placeholder = "Enter username here"
    tf.accessibilityIdentifier = "usernameTF"
    tf.isAccessibilityElement = true
    tf.autocapitalizationType = .none
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  private let passwordField : UITextField = {
    let tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.isSecureTextEntry = true
    tf.tag = 1
    tf.placeholder = "Enter password here"
    tf.accessibilityIdentifier = "passwordTF"
    tf.isAccessibilityElement = true
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Masuk", for: .normal)
    button.layer.cornerRadius = 8
    button.isEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Daftar", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.isEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.primaryColor
    view.layer.cornerRadius = 8
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  public init(useCase: LoginUseCase, navigator: AppNavigator) {
    self.useCase = useCase
    self.navigator = navigator
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .white
    
    observer()
    
    setupView()
  }
  
  private func setupView() {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(usernameField)
    stackView.addArrangedSubview(passwordField)
    stackView.addArrangedSubview(loginButton)
    stackView.addArrangedSubview(registerButton)
    
    view.addSubview(label)
    view.addSubview(containerView)
    containerView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -24),
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      containerView.heightAnchor.constraint(equalToConstant: 230),
      stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
      stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
      stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
    ])
    
    usernameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    passwordField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    registerButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    
    loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    registerButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
  }
  
  fileprivate func showLoading() {
    let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    progressHUD.mode = .indeterminate
    progressHUD.label.text = "Loading"
  }
  
  fileprivate func hideLoading() {
    MBProgressHUD.hide(for: self.view, animated: true)
  }
  
  private func observer() {
    let formValid = Observable.combineLatest(
      usernameField.rx.text.orEmpty,
      passwordField.rx.text.orEmpty
    ).map { username, password in
      return !username.isEmpty && !password.isEmpty
    }
    
    formValid
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    formValid
      .subscribe(onNext: { [weak self] isValid in
        self?.loginButton.backgroundColor = isValid ? .systemBlue : .systemGray
        self?.loginButton.setTitleColor(isValid ? .white : .systemGray2, for: .normal)
      })
      .disposed(by: disposeBag)
  }
  
  @objc func signIn() {
    showLoading()
    
    let username = usernameField.text ?? ""
    let password = passwordField.text ?? ""
    
    useCase.login(
      username: username,
      password: password
    )
    .subscribe { [weak self] _ in
      self?.navigator.navigateToSignedIn()
      self?.hideLoading()
    } onFailure: { [weak self] error in
      guard let error = error as? ErrorMessage else { return }
      self?.showErrorAlert(title: error.title, msg: error.message)
      self?.hideLoading()
    }.disposed(by: disposeBag)
  }
  
  @objc func signUp() {
    navigator.navigateToRegister()
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
