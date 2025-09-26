//
//  Paramable.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//


import Foundation

public protocol Paramable {
  func toParam() -> [String: Any]
}
