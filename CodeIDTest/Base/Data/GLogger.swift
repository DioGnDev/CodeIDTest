//
//  GLogger.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation

public func NLog(_ title: String, _ message: Any) {
  print("🧲 \(title) : \(message)")
}

public func GLogger(
  _ key: KeyLogger,
  layer: String,
  message: Any,
  file: String = #file,
  function: String = #function,
  line: Int = #line
) {
  NLog(
    key,
    layer: layer,
    message: message,
    file: file,
    function: function,
    line: line
  )
}
