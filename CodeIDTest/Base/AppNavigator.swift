//
//  ListResponder.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation

public protocol AppNavigator {
  func navigateToSignedIn(_ userSession: UserSession)
}
