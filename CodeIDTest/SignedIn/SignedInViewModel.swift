//
//  SignedInViewModel.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public enum SignedInView {
  case tab
  case detail
}

public typealias SignedInNavigationAction = NavigationAction<SignedInView>

public class SignedInViewModel {
  
  public private(set) var view = BehaviorSubject<SignedInNavigationAction>(value: .present(view: .tab))
  
  public func navigateToTab() {
    view.onNext(.present(view: .tab))
  }
  
  public func navigateToDetail(argument: String) {
    view.onNext(.present(view: .detail))
  }
  
}

extension SignedInViewModel: SignedInNavigator {}
