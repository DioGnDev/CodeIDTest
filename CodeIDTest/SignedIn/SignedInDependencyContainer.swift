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
    self.service = dependencyInjection.service
    self.sharedViewModel = SignedInViewModel()
  }
  
  //MARK: - Make ViewController
  
  public func makeViewController() -> SignedInContainerController {
    
    let detailFactory = { arg in
      self.makeDetailViewController(name: arg)
    }
    
    return SignedInContainerController(
      viewModel: sharedViewModel,
      pagerTabViewController: makePokeTabViewController(),
      makeDetailViewControllerFactory: detailFactory
    )
  }
  
  private func makePokeTabViewController() -> PokeTabViewController {
    let listFactory = {
      self.makePokeListViewController()
    }
    
    let profileFactory = {
      self.makeProfileViewController()
    }
    
    return PokeTabViewController(
      makeListViewController: listFactory,
      makeProfileViewController: profileFactory
    )
  }
  
  //  private func makeListViewController() -> ListViewController {
  //    func makeRemote() -> ListRemoteDataSource {
  //      return ListRemoteDataSourceImpl(service: service)
  //    }
  //
  //    func makeRepository() -> ListRepository {
  //      return ListRepositoryImpl(remote: makeRemote())
  //    }
  //
  //    func makeCachedRepository() -> CachedRepository {
  //      return CachedRepositoryImpl(context: context)
  //    }
  //
  //    func makeUseCase() -> ListUseCase {
  //      return ListUseCase(
  //        repository: makeRepository(),
  //        cache: makeCachedRepository()
  //      )
  //    }
  //
  //    return ListViewController(useCase: makeUseCase())
  //  }
  
  private func makePokeListViewController() -> PokeListViewController {
    func makeRemote() -> PokemonRemoteDataSource {
      return PokemonRemoteDataSourceImpl(service: service)
    }
    
    func makeRepository() -> PokemonRepository {
      return PokemonRepositoryImpl(remote: makeRemote())
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
    
    return PokeListViewController(
      useCase: makeUseCase(),
      navigator: sharedViewModel
    )
  }
  
  private func makeDetailViewController(name: String) -> DetailViewController {
    func makeRemote() -> PokemonRemoteDataSource {
      return PokemonRemoteDataSourceImpl(service: service)
    }
    
    func makeRepo() -> PokemonRepository {
      return PokemonRepositoryImpl(remote: makeRemote())
    }
    
    func makeUseCase() -> DetailUseCase {
      return DetailUseCase(repo: makeRepo())
    }
    
    return DetailViewController(name: name, useCase: makeUseCase())
  }
  
  private func makeProfileViewController() -> ProfileViewController {
    return ProfileViewController()
  }
  
}

extension SignedInDependencyContainer {
  
}
