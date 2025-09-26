//
//  AppViewModel.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public enum AppView {
  case launching
  case login
  case signedIn
}

public typealias AppNavigationAction = NavigationAction<AppView>

public class AppViewModel {
  
  public private(set) var view = BehaviorSubject<AppNavigationAction>(value: .present(view: .launching))
  
  public func gotoLogin() {
    view.onNext(.present(view: .login))
  }
  
  public func navigateToSignedIn() {
    view.onNext(.present(view: .signedIn))
  }
}

extension AppViewModel: LoginResponder,
                        AppNavigator {}
