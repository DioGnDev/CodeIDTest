//
//  PokeTabViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import UIKit
import XLPagerTabStrip

public class PokeTabViewController: ButtonBarPagerTabStripViewController {
  
  var isReload = false
  let graySpotifyColor = UIColor(red: 60/255.0, green: 70/255.0, blue: 123/255.0, alpha: 1.0)
  let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
  
  private let makeListViewController: () -> PokeListViewController
  private let makeProfileViewController: () -> ProfileViewController
  
  public init(
    makeListViewController: @escaping () -> PokeListViewController,
    makeProfileViewController: @escaping () -> ProfileViewController
  ) {
    self.makeListViewController = makeListViewController
    self.makeProfileViewController = makeProfileViewController
    
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    // change selected bar color
    settings.style.buttonBarBackgroundColor = graySpotifyColor
    settings.style.buttonBarItemBackgroundColor = graySpotifyColor
    settings.style.selectedBarBackgroundColor = .yellow
    settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
    settings.style.selectedBarHeight = 3.0
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemTitleColor = .black
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarHeight = 100
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    
    view.backgroundColor = .white
    
    changeCurrentIndexProgressive = { (
      oldCell: ButtonBarViewCell?,
      newCell: ButtonBarViewCell?,
      progressPercentage: CGFloat,
      changeCurrentIndex: Bool,
      animated: Bool
    ) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = UIColor(red: 138/255.0, green: 138/255.0, blue: 144/255.0, alpha: 1.0)
      newCell?.label.textColor = .white
    }
    
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
  }
  
  public override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let listVC = makeListViewController()
    let profileVC = makeProfileViewController()
    return [listVC, profileVC]
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}
