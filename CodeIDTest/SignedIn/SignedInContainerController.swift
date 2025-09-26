//
//  SignedInContainerController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift

public class SignedInContainerController: NiblessNavigationController {
  
  let viewModel: SignedInViewModel
  let listViewController: ListViewController
  let detailViewController: DetailViewController
  
  var disposeBag = DisposeBag()
  
  public init(
    viewModel: SignedInViewModel,
    listViewController: ListViewController,
    detailViewController: DetailViewController
  ) {
    self.viewModel = SignedInViewModel()
    self.listViewController = listViewController
    self.detailViewController = detailViewController
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    subscribe(viewModel.view.asObservable())
  }
  
  private func subscribe(_ observable: Observable<SignedInNavigationAction>) {
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
  
  private func respond(_ navigation: SignedInNavigationAction) {
    switch navigation {
    case .present(let view):
      self.present(view)
    case .presented:
      break
    }
  }
  
  private func present(_ view: SignedInView) {
    switch view {
    case .list:
      presentList()
    case .detail:
      presentDetail()
    }
  }
  
  private func presentList() {
    pushViewController(listViewController, animated: true)
  }
  
  private func presentDetail() {
    pushViewController(detailViewController, animated: true)
  }
  
}
