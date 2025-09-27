//
//  Pagination.swift
//  
//
//  Created by Ilham Hadi P. on 24/05/22.
//

import UIKit

public protocol Paginateable {
  
  var viewModel: PaginationModel? { get set }
  
  func scrollViewDidScroll(
    scrollView: UIScrollView,
    height: CGFloat,
    completion: @escaping (() -> Void)
  )
  
}

public struct PaginationModel {
  
  public var count: Int
  public var next: String?
  public var limit: Int
  
  public init(){
    self.count = 0
    self.next = ""
    self.limit = 10
  }
  
  public init(
    count: Int,
    next: String? = nil,
    limit: Int = 10
  ) {
    self.count = count
    self.next = next
    self.limit = limit
  }
  
}

open class Pagination: Paginateable {
  
  public var viewModel: PaginationModel?
  
  public init(){
    
  }
  
  open func scrollViewDidScroll(
    scrollView: UIScrollView,
    height: CGFloat,
    completion: @escaping (() -> Void)
  ) {
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
      //reach bottom
      let position = scrollView.contentOffset.y
      if position > (height - 50 - scrollView.frame.size.height) {
        completion()
      }
      
    }
    
  }
  
  
}
