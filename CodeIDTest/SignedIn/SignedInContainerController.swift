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
  let detailViewController: DetailViewController
  
  var disposeBag = DisposeBag()
  
  public init(
    viewModel: SignedInViewModel,
    pagerTabViewController: PokeTabViewController,
    detailViewController: DetailViewController
  ) {
    self.viewModel = SignedInViewModel()
    self.pagerTabViewController = pagerTabViewController
    self.detailViewController = detailViewController
    
    super.init()
    
    self.delegate = self
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
    case .tab:
      presentPagerTab()
    case .detail:
      presentDetail()
    }
  }
  
  private func presentPagerTab() {
    pushViewController(pagerTabViewController, animated: true)
  }
  
  private func presentDetail() {
    pushViewController(detailViewController, animated: true)
  }
  
}

extension SignedInContainerController: UINavigationControllerDelegate {
  
  public func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool
  ) {
    setNavigationBarHidden(true, animated: false)
  }
  
  public func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    setNavigationBarHidden(true, animated: false)
  }
  
}
