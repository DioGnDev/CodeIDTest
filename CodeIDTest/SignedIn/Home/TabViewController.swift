//
//  TabViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import UIKit
import XLPagerTabStrip

public class TabViewController: ButtonBarPagerTabStripViewController {
  
  let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)

  public override func viewDidLoad() {
    // change selected bar color
    settings.style.buttonBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = blueInstagramColor
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.selectedBarHeight = 2.0
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemTitleColor = .black
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    
    changeCurrentIndexProgressive = { [weak self] (
      oldCell: ButtonBarViewCell?,
      newCell: ButtonBarViewCell?,
      progressPercentage: CGFloat,
      changeCurrentIndex: Bool,
      animated: Bool
    ) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = .black
      newCell?.label.textColor = self?.blueInstagramColor
    }
    
    super.viewDidLoad()
  }
  
  public override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let listVC = ListViewController(useCase: ListUseCase(
      repository: ListRepositoryImpl(remote: ListRemoteDataSourceImpl(service: NetworkService())),
      cache: CachedRepositoryImpl(
        context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      )
    ))
                                    
    let profileVC = ProfileViewController()
    return [listVC, profileVC]
  }
  
}
