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
  let pagerTabViewController: PokeTabViewController
  let makeDetailViewController: (String) -> DetailViewController
  
  var detailViewController: DetailViewController?
  
  var disposeBag = DisposeBag()
  
  public init(
    viewModel: SignedInViewModel,
    pagerTabViewController: PokeTabViewController,
    makeDetailViewControllerFactory: @escaping (String) -> DetailViewController
  ) {
    self.viewModel = viewModel
    self.pagerTabViewController = pagerTabViewController
    self.makeDetailViewController = makeDetailViewControllerFactory
    
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
          GLogger(.info, layer: "presentation", message: "error")
        },
        onCompleted: {
          GLogger(.info, layer: "presentation", message: "completed")
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
    case .tab:
      presentPagerTab()
    case .detail(let name):
      presentDetail(name: name)
    }
  }
  
  private func presentPagerTab() {
    pushViewController(pagerTabViewController, animated: true)
  }
  
  private func presentDetail(name: String) {
    pushViewController(makeDetailViewController(name), animated: true)
  }
  
}
