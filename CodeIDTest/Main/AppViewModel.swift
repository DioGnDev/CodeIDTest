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
  case register
  case signedIn
}

extension AppView: Equatable {
  public static func ==(lhs: AppView, rhs: AppView) -> Bool {
    switch (lhs, rhs) {
    case (.launching, .launching):
      return true
    case (.login, .login):
      return true
    case (.signedIn, .signedIn):
      return true
    case (.register, .register):
      return true
    case (.launching, _),
      (.login, _),
      (.signedIn, _),
      (.register, _):
      return false
    }
  }
}

public typealias AppNavigationAction = NavigationAction<AppView>

public class AppViewModel {
  
  public private(set) var view = BehaviorSubject<AppNavigationAction>(value: .present(view: .launching))
  
  public func gotoLogin() {
    view.onNext(.present(view: .login))
  }
  
  public func navigateToLogin() {
    view.onNext(.present(view: .login))
  }
  
  public func navigateToRegister() {
    view.onNext(.present(view: .register))
  }
  
  public func navigateToSignedIn() {
    view.onNext(.present(view: .signedIn))
  }
  
}

extension AppViewModel: LoginResponder,
                        AppNavigator {
 
}
