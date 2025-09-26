//
//  LaunchViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit

public class LaunchViewController: NiblessViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .purple
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
