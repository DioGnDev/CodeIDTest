//
//  LoginViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit

public class LoginViewController: NiblessViewController {
  
  private let useCase: LoginUseCase
  private let navigator: AppNavigator
  
  public init(useCase: LoginUseCase, navigator: AppNavigator) {
    self.useCase = useCase
    self.navigator = navigator
    super.init()
  }
 
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .brown
    
    observer()
    
    useCase.login(name: "test", email: "test@gmail.com")
    
  }
  
  private func observer() {
    
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
  
}
