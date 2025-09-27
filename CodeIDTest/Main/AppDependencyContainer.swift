//
//  AppDependencyContainer.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation
import UIKit
import CoreData

public class AppDependencyContainer {
  
  //MARK: - Long Lived Dependency
  public let context: NSManagedObjectContext
  public let userSessionRepository: UserSessionRepository
  public let sharedViewModel: AppViewModel
  public var userSession: UserSession!
  public let service: Service
  private var authDataSource: AuthDataSource!
  private var authRepository: AuthRepository!
  
  public init(context: NSManagedObjectContext) {
    func makeUserSessionRepository() -> UserSessionRepository {
      return UserDefaultSessionRepository()
    }
    
    self.context = context
    self.userSessionRepository = makeUserSessionRepository()
    self.sharedViewModel = AppViewModel()
    self.service = NetworkService()
    self.authDataSource = AuthLocalDataSourceImpl(context: context)
    self.authRepository = AuthRepositoryImpl(dataSource: authDataSource)
  }
  
  //MARK: - Make ViewController
  
  public func makeViewController() -> AppContainerController {
    let launchFactory = {
      return self.makeLaunchViewController()
    }
    
    let loginFactory = {
      return self.makeLoginViewController()
    }
    
    let signedInFactory = {
      return self.makeSignedInViewController()
    }
    
    let registerFactory = {
      return self.makeRegisterViewController()
    }
    
    return AppContainerController(
      sharedViewModel: sharedViewModel,
      makeLaunchViewControllerFactory: launchFactory,
      makeLoginViewControllerFactory: loginFactory,
      makeSignedInViewControllerFactory: signedInFactory,
      makeRegisterViewControllerFactory: registerFactory
    )
    
  }
  
  private func makeLaunchViewController() -> LaunchViewController {
   
    func makeRepository() -> IsSignedInRepository {
      return LaunchRepositoryImpl(remote: authDataSource)
    }
    
    func makeUseCase() -> LaunchUseCase {
      return LaunchUseCase(repo: makeRepository())
    }
    
    return LaunchViewController(
      useCase: makeUseCase(),
      responder: sharedViewModel,
      navigator: sharedViewModel
    )
  }
  
  private func makeLoginViewController() -> LoginViewController {
    func makeUseCase() -> LoginUseCase {
      return LoginUseCase(authRepo: authRepository)
    }
    
    return LoginViewController(
      useCase: makeUseCase(),
      navigator: sharedViewModel
    )
  }
  
  private func makeRegisterViewController() -> RegisterViewController {
    return RegisterViewController(
      useCase: RegisterUseCase(authRepo: authRepository),
      navigator: sharedViewModel
    )
  }
  
  private func makeSignedInViewController() -> SignedInContainerController {
    return SignedInDependencyContainer(dependencyInjection: self).makeViewController()
  }
  
  
  
}

extension AppDependencyContainer {
  
}
