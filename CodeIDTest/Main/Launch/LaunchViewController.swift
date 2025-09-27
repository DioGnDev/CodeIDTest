//
//  LaunchViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift

public class LaunchViewController: NiblessViewController {
  
  private let useCase: LaunchUseCase
  private let responder: LoginResponder
  private let navigator: AppNavigator
  
  private var disposeBag = DisposeBag()
  
  public init(
    useCase: LaunchUseCase,
    responder: LoginResponder,
    navigator: AppNavigator
  ) {
    self.useCase = useCase
    self.responder = responder
    self.navigator = navigator
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .white
    
    observer()
    
    useCase.loadUserSession()
      .subscribe { [weak self] state in
        if state {
          self?.navigator.navigateToSignedIn()
        } else {
          self?.responder.gotoLogin()
        }
      } onFailure: { [weak self] error in
        guard let error = error as? ErrorMessage else { return }
        self?.showErrorAlert(title: error.title, msg: error.message)
      }
      .disposed(by: disposeBag)
  }
  
  private func observer() {
    
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
