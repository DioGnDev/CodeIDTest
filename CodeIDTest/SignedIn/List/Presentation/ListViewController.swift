//
//  ListViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit
import RxSwift
import XLPagerTabStrip

public class ListViewController: BaseTableViewController, IndicatorInfoProvider {
  
  let useCase: ListUseCase
  var itemInfo = IndicatorInfo(title: "View")
  
  private let disposeBag = DisposeBag()
  
  public init(useCase: ListUseCase) {
    self.useCase = useCase
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
   
    print("current_vc: - \(self.self)")
    
    useCase.loadItems()
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
      .observe(on: MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] results in
        self?.items = results.map { PokeTableItemModel(
          id: $0.id?.uuidString ?? "",
          type: PokeTableViewCell.self,
          identifier: PokeTableViewCell.identifier,
          name: $0.name ?? ""
        )}
      }).disposed(by: disposeBag)
  }
  
  public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return itemInfo
  }
  
}
