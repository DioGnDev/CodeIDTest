//
//  SignedInDependencyContainer.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import CoreData
import UIKit

public class SignedInDependencyContainer {
  
  //MARK: - Long Lived Dependency
  private let sharedViewModel: SignedInViewModel
  private let context: NSManagedObjectContext
  private let service: Service
  
  public init(dependencyInjection: AppDependencyContainer) {
    self.context = dependencyInjection.context
    self.sharedViewModel = SignedInViewModel()
    self.service = dependencyInjection.service
  }
  
  //MARK: - Make ViewController
  
  public func makeViewController() -> SignedInContainerController {
    return SignedInContainerController(
      viewModel: sharedViewModel,
      pagerTabViewController: makePokeTabViewController(),
      detailViewController: makeDetailViewController()
    )
  }
  
  private func makePokeTabViewController() -> PokeTabViewController {
    let listFactory = {
      self.makeListViewController()
    }
    
    let profileFactory = {
      self.makeProfileViewController()
    }
    
    return PokeTabViewController(
      makeListViewController: listFactory,
      makeProfileViewController: profileFactory
    )
  }
  
  private func makeListViewController() -> ListViewController {
    func makeRemote() -> ListRemoteDataSource {
      return ListRemoteDataSourceImpl(service: service)
    }
    
    func makeRepository() -> ListRepository {
      return ListRepositoryImpl(remote: makeRemote())
    }
    
    func makeCachedRepository() -> CachedRepository {
      return CachedRepositoryImpl(context: context)
    }
    
    func makeUseCase() -> ListUseCase {
      return ListUseCase(
        repository: makeRepository(),
        cache: makeCachedRepository()
      )
    }
    
    return ListViewController(useCase: makeUseCase())
  }
  
  private func makeDetailViewController() -> DetailViewController {
    return DetailViewController()
  }
  
  private func makeProfileViewController() -> ProfileViewController {
    return ProfileViewController()
  }
  
}

extension SignedInDependencyContainer {
  
}
