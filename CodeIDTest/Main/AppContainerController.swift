//
//  AppContainerController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import UIKit
import RxSwift

public class AppContainerController: NiblessViewController {
  
  let sharedViewModel: AppViewModel
  
  let makeLaunchViewController: () -> LaunchViewController
  let makeLoginViewController: () -> LoginViewController
  let makeSignedInViewController: (UserSession) -> SignedInContainerController
  
  var launchViewController: LaunchViewController?
  var loginViewController: LoginViewController?
  var signedViewController: SignedInContainerController?
  
  var disposeBag = DisposeBag()
  
  public init(
    sharedViewModel: AppViewModel,
    makeLaunchViewControllerFactory: @escaping() -> LaunchViewController,
    makeLoginViewControllerFactory: @escaping () -> LoginViewController,
    makeSignedInViewControllerFactory: @escaping (UserSession) -> SignedInContainerController
  ) {
    self.sharedViewModel = sharedViewModel
    self.makeLaunchViewController = makeLaunchViewControllerFactory
    self.makeLoginViewController = makeLoginViewControllerFactory
    self.makeSignedInViewController = makeSignedInViewControllerFactory
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    subscribe(sharedViewModel.view.asObservable())
    
  }
  
  private func subscribe(_ observable: Observable<AppNavigationAction>) {
    observable
      .observe(on: MainScheduler.instance)
      .subscribe(
        onNext: { navigation in
          self.respond(navigation)
        },
        onError: { _ in
          
        }
      )
      .disposed(by: disposeBag)
  }
  
  private func respond(_ navigation: AppNavigationAction) {
    switch navigation {
    case .present(let view):
      self.present(view)
    case .presented:
      break
    }
  }
  
  private func present(_ view: AppView) {
    switch view {
    case .launching:
      presentLaunch()
    case .login:
      presentLogin()
    case .signedIn(let userSession):
      presentSignedIn(userSession)
    }
  }
  
  private func presentLaunch() {
    let viewControllerToPresent: LaunchViewController
    
    if let vc = self.launchViewController {
      viewControllerToPresent = vc
    } else {
      viewControllerToPresent = makeLaunchViewController()
      self.launchViewController = viewControllerToPresent
    }
    
    addFullScreen(childViewController: viewControllerToPresent)
  }
  
  private func presentLogin() {
    let viewControllerToPresent: LoginViewController
    
    if let vc = self.loginViewController {
      viewControllerToPresent = vc
    } else {
      viewControllerToPresent = makeLoginViewController()
      self.loginViewController = viewControllerToPresent
    }
    
    viewControllerToPresent.modalPresentationStyle = .fullScreen
    present(viewControllerToPresent, animated: true)
  }
  
  private func presentSignedIn(_ userSession: UserSession) {
    remove(childViewController: launchViewController)
    launchViewController = nil
    
    if let _ = loginViewController {
      dismiss(animated: true)
      loginViewController = nil
    }
    
    let viewControllerToPresent: SignedInContainerController
    
    if let vc = self.signedViewController {
      viewControllerToPresent = vc
    } else {
      viewControllerToPresent = makeSignedInViewController(userSession)
      self.signedViewController = viewControllerToPresent
    }
    
    addFullScreen(childViewController: viewControllerToPresent)
  }
  
}
