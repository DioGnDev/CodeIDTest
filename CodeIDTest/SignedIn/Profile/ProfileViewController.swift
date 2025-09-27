//
//  ProfileViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import UIKit
import XLPagerTabStrip

public class ProfileViewController: NiblessViewController, IndicatorInfoProvider {
  
  var itemInfo = IndicatorInfo(title: "View")

  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .yellow
  }
  
  public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    
    return itemInfo
  }
  
}
