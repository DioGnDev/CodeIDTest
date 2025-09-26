//
//  SignedInDependencyContainer.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

public class SignedInDependencyContainer {
  
  //MARK: - Long Lived Dependency
  private let sharedViewModel: SignedInViewModel
  
  public init() {
    self.sharedViewModel = SignedInViewModel()
  }
  
  //MARK: - Make ViewController
  
  public func makeViewController() -> SignedInContainerController {
    
    return SignedInContainerController(
      viewModel: sharedViewModel,
      listViewController: makeListViewController(),
      detailViewController: makeDetailViewController()
    )
    
  }
  
  private func makeListViewController() -> ListViewController {
    return ListViewController()
  }
  
  private func makeDetailViewController() -> DetailViewController {
    return DetailViewController()
  }
  
  //MARK: - Make ViewModel
  
}

extension SignedInDependencyContainer {
  
}
