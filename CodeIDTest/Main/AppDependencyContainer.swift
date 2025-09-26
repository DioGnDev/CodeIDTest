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
    
    let signedInFactory = { userSession in
      return self.makeSignedInViewController(userSession)
    }
    
    return AppContainerController(
      sharedViewModel: sharedViewModel,
      makeLaunchViewControllerFactory: launchFactory,
      makeLoginViewControllerFactory: loginFactory,
      makeSignedInViewControllerFactory: signedInFactory
    )
    
  }
  
  private func makeLaunchViewController() -> LaunchViewController {
    
    func makeUseCase() -> LaunchUseCase {
      return LaunchUseCase(userSessionRepository: userSessionRepository)
    }
    
    return LaunchViewController(
      useCase: makeUseCase(),
      responder: sharedViewModel,
      navigator: sharedViewModel
    )
  }
  
  private func makeLoginViewController() -> LoginViewController {
    return LoginViewController(
      useCase: LoginUseCase(userSessionRepository: userSessionRepository),
      navigator: sharedViewModel
    )
  }
  
  private func makeSignedInViewController(_ userSession: UserSession) -> SignedInContainerController {
    return SignedInDependencyContainer(userSession: userSession).makeViewController()
  }
  
}

extension AppDependencyContainer {
  
}
