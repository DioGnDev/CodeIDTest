//
//  AppDependencyContainer.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation

public class AppDependencyContainer {
  
  //MARK: - Long Lived Dependency
  private let userSessionRepository: UserSessionRepository
  private let sharedViewModel: AppViewModel
  
  public init() {
    func makeUserSessionRepository() -> UserSessionRepository {
      return UserDefaultSessionRepository()
    }
    
    self.userSessionRepository = makeUserSessionRepository()
    self.sharedViewModel = AppViewModel()
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
    
    return AppContainerController(
      sharedViewModel: sharedViewModel,
      makeLaunchViewControllerFactory: launchFactory,
      makeLoginViewControllerFactory: loginFactory,
      makeSignedInViewControllerFactory: signedInFactory
    )
    
  }
  
  private func makeLaunchViewController() -> LaunchViewController {
    return LaunchViewController()
  }
  
  private func makeLoginViewController() -> LoginViewController {
    return LoginViewController(
      usecase: LoginUseCase(),
      navigator: sharedViewModel
    )
  }
  
  private func makeSignedInViewController() -> SignedInContainerController {
    return SignedInDependencyContainer().makeViewController()
  }
  
}

extension AppDependencyContainer {
  
}
