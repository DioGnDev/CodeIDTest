//
//  LoginViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift

public class LoginViewController: NiblessViewController {
  
  private let useCase: LoginUseCase
  private let navigator: AppNavigator
  
  private var disposeBag = DisposeBag()
  
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
    
  }
  
  private func observer() {
    useCase.showError
      .subscribe(
        onNext: { error in
          print("error \(error)")
        }
      )
      .disposed(by: disposeBag)
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
  
}
