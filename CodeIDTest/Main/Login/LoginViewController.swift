//
//  LoginViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit

public class LoginViewController: NiblessViewController {
  
  private let usecase: LoginUseCase
  private let navigator: AppNavigator
  
  public init(usecase: LoginUseCase, navigator: AppNavigator) {
    self.usecase = usecase
    self.navigator = navigator
    super.init()
  }
 
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .brown
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
  
}
