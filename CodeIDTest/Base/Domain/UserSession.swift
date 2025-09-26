//
//  UserSession.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import Foundation

public class UserSession: Codable{
  public private(set) var name: String
  public private(set) var email: String
  
  public init() {
    self.name = ""
    self.email = ""
  }
  
  public init(name: String, email: String) {
    self.name = name
    self.email = email
  }
  
}

extension UserSession: Equatable {
  
  public static func == (lhs: UserSession, rhs: UserSession) -> Bool {
    return lhs.name == rhs.name
  }
  
}

public struct RemoteSession: Codable {
  public let token: String
  public let fcmToken: String
  
  public init() {
    self.token = ""
    self.fcmToken = ""
  }
  
  public init(token: String, fcmToken: String) {
    self.token = token
    self.fcmToken = fcmToken
  }
  
}

extension RemoteSession: Equatable {
  
}
