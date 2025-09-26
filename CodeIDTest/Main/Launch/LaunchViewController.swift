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
    
    view.backgroundColor = .purple
    
    observer()
    
    useCase.loadUserSession()
  }
  
  private func observer() {
    useCase.presentLogin
      .distinctUntilChanged()
      .subscribe { [weak self] user in
        self?.responder.gotoLogin()
      }.disposed(by: disposeBag)
    
    useCase.navigateToList
      .distinctUntilChanged()
      .subscribe { [weak self] session in
        self?.navigator.navigateToSignedIn(session)
      }.disposed(by: disposeBag)
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
