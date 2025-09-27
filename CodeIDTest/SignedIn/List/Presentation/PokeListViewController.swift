//
//  PokeListViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation
import UIKit
import RxSwift
import XLPagerTabStrip

public class PokeListViewController: NiblessViewController, IndicatorInfoProvider {
  
  //Dependency
  let useCase: ListUseCase
  
  //Property
  var items: [PokeEntity] = []
  
  private let disposeBag = DisposeBag()
  
  private var footerView: LoadingFooterView!
  
  lazy var tableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.dataSource = self
    tv.delegate = self
    tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tv.backgroundColor = .white
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.tableFooterView = footerView
    return tv
  }()
  
  public init(useCase: ListUseCase) {
    self.useCase = useCase
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .clear
    
    setupView()
    
    useCase.loadItems()
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] item in
        self?.items = item
        self?.tableView.reloadData()
      }.disposed(by: disposeBag)
  }
  
  private func setupView() {
    footerView = LoadingFooterView(frame: .init(x: 0, y: 0, width: tableView.bounds.width, height: 60))
    tableView.tableFooterView = footerView
    
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
      let position = scrollView.contentOffset.y
      if position > (tableView.contentSize.height - 50 - scrollView.frame.size.height) {
        footerView.startLoading()
        
        useCase.loadMore()
          .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
          .observe(on: MainScheduler.instance)
          .subscribe { [weak self] item in
            self?.items.append(contentsOf: item)
            self?.tableView.reloadData()
            self?.footerView.stopLoading()
          }.disposed(by: disposeBag)
      }
    }
  }
  
  deinit {
    print("deinit: - \(self.self)")
  }
  
}

extension PokeListViewController: UITableViewDataSource, UITableViewDelegate {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return items.count
  }
  
  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    let item = items[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = item.name
    
    return cell
  }
  
  public func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
    
    return "Pokemon"
  }
  
}
