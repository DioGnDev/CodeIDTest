//
//  SignedInViewModel.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public enum SignedInView {
  case tab
  case detail(String)
}

extension SignedInView: Equatable {
  public static func ==(lhs: SignedInView, rhs: SignedInView) -> Bool {
    switch (lhs, rhs) {
    case (.tab, .tab):
      return true
    case let (.detail(l), .detail(r)):
      return l == r
    default:
      return false
    }
  }
}

public typealias SignedInNavigationAction = NavigationAction<SignedInView>

public class SignedInViewModel {
  
  public private(set) var view = BehaviorSubject<SignedInNavigationAction>(value: .present(view: .tab))
  
  public func navigateToTab() {
    view.onNext(.present(view: .tab))
  }
  
  public func navigateToDetail(name: String) {
    view.onNext(.present(view: .detail(name)))
  }
  
}

extension SignedInViewModel: SignedInNavigator {}
