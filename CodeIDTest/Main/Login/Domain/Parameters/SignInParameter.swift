//
//  SignInParameter.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

public struct SignInParameter: Paramable {
  public let name: String
  public let email: String
  
  public func toParam() -> [String : Any] {
    return [
      "name" : name,
      "email" : email
    ]
  }
  
}
