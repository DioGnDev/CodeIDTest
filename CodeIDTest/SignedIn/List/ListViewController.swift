//
//  ListViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit

public class ListViewController: NiblessViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .yellow
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
