//
//  Pagination.swift
//  
//
//  Created by Ilham Hadi P. on 24/05/22.
//

import UIKit

public protocol Paginateable {
  
  var viewModel: PaginationViewModel? { get set }
  
  func scrollViewDidScroll(
    scrollView: UIScrollView,
    height: CGFloat,
    completion: @escaping (() -> Void)
  )
  
}

public struct PaginationViewModel {
  
  public var currentPage: Int
  public var nextPage: Int
  public var totalPage: Int
  public var pageSize: Int
  
  public init(){
    self.currentPage = 0
    self.nextPage = 0
    self.totalPage = 0
    self.pageSize = 0
  }
  
  public init(currentPage: Int,
              nextPage: Int,
              totalPage: Int,
              pageSize: Int) {
    
    self.currentPage = currentPage
    self.nextPage = nextPage
    self.totalPage = totalPage
    self.pageSize = pageSize
  }
  
}

open class Pagination: Paginateable {
  
  public var viewModel: PaginationViewModel?
  
  public init(){
    
  }
  
  open func scrollViewDidScroll(scrollView: UIScrollView,
                                height: CGFloat,
                                completion: @escaping (() -> Void)) {
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
      //reach bottom
      let position = scrollView.contentOffset.y
      if position > (height - 50 - scrollView.frame.size.height) {
        completion()
      }
      
    }
    
  }
  
  
}
