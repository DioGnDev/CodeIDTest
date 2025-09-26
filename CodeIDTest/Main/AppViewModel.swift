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
  case signedIn(UserSession)
}

extension AppView: Equatable {
  public static func ==(lhs: AppView, rhs: AppView) -> Bool {
    switch (lhs, rhs) {
    case (.launching, .launching):
      return true
    case (.login, .login):
      return true
    case let (.signedIn(l), .signedIn(r)):
      return l == r
    case (.launching, _),
      (.login, _),
      (.signedIn, _):
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
  
  
  public func navigateToSignedIn(_ userSession: UserSession) {
    view.onNext(.present(view: .signedIn(userSession)))
  }
  
}

extension AppViewModel: LoginResponder,
                        AppNavigator {}
