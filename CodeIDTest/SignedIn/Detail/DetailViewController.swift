//
//  DetailViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit

public class DetailViewController: NiblessViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .red
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
