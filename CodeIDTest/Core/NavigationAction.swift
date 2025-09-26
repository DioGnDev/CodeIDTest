//
//  NavigationAction.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//


public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {
  case present(view: ViewModelType)
  case presented(view: ViewModelType)
}