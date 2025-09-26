//
//  SignedInViewModel.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import RxSwift

public enum SignedInView {
  case list
  case detail
}

public typealias SignedInNavigationAction = NavigationAction<SignedInView>

public class SignedInViewModel {
  
  public private(set) var view = BehaviorSubject<SignedInNavigationAction>(value: .present(view: .list))
  
  public func navigateToList() {
    view.onNext(.present(view: .list))
  }
  
  public func navigateToDetail(argument: String) {
    view.onNext(.present(view: .detail))
  }
  
}

extension SignedInViewModel: SignedInNavigator {}
