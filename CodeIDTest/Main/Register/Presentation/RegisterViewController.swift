//
//  RegisterViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift
import MBProgressHUD

public class RegisterViewController: NiblessViewController {
  
  private let useCase: RegisterUseCase
  private let navigator: AppNavigator
  
  private var disposeBag = DisposeBag()
  
  private let label: UILabel = {
    let lbl = UILabel()
    lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.text = "Register"
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
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  private let emailField: UITextField = {
    let tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.autocapitalizationType = .none
    tf.keyboardType = .emailAddress
    tf.tag = 1
    tf.placeholder = "Enter email here"
    tf.accessibilityIdentifier = "usernameTF"
    tf.isAccessibilityElement = true
    tf.autocapitalizationType = .none
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let passwordField : UITextField = {
    let tf = UITextField()
    tf.borderStyle = .roundedRect
    tf.isSecureTextEntry = true
    tf.tag = 2
    tf.placeholder = "Enter password here"
    tf.accessibilityIdentifier = "passwordTF"
    tf.isAccessibilityElement = true
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Daftar", for: .normal)
    button.layer.cornerRadius = 8
    button.isEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Masuk", for: .normal)
    button.layer.cornerRadius = 8
    button.isEnabled = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  public init(useCase: RegisterUseCase, navigator: AppNavigator) {
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
    stackView.addArrangedSubview(emailField)
    stackView.addArrangedSubview(passwordField)
    stackView.addArrangedSubview(signUpButton)
    stackView.addArrangedSubview(loginButton)
    
    view.addSubview(label)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -24),
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
    ])
    
    usernameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    passwordField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
  }
  
  fileprivate func showLoading() {
    let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    progressHUD.mode = .annularDeterminate
    progressHUD.label.text = "Loading"
    progressHUD.completionBlock = { [weak self] in
      self?.navigator.navigateToLogin()
    }
  }
  
  fileprivate func hideLoading() {
    MBProgressHUD.hide(for: self.view, animated: true)
  }
  
  private func observer() {
    let formValid = Observable.combineLatest(
      usernameField.rx.text.orEmpty,
      passwordField.rx.text.orEmpty,
      emailField.rx.text.orEmpty
    ).map { username, password, email in
      return !username.isEmpty && !password.isEmpty && !email.isEmpty
    }
    
    formValid
      .bind(to: signUpButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    formValid
      .subscribe(onNext: { [weak self] isValid in
        self?.signUpButton.backgroundColor = isValid ? .systemBlue : .systemGray
        self?.signUpButton.setTitleColor(isValid ? .white : .systemGray2, for: .normal)
      })
      .disposed(by: disposeBag)
  }
  
  @objc func signUp() {
    showLoading()
    
    let username = usernameField.text ?? ""
    let password = passwordField.text ?? ""
    let email = emailField.text ?? ""
    
    useCase.register(
      username: username,
      email: email,
      password: password
    )
    .subscribe { [weak self] _ in
      self?.hideLoading()
    } onFailure: { [weak self] error in
      guard let error = error as? ErrorMessage else { return }
      self?.showErrorAlert(title: error.title, msg: error.message)
      self?.hideLoading()
    }.disposed(by: disposeBag)
  }
  
  @objc func signIn() {
    navigator.navigateToLogin()
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
