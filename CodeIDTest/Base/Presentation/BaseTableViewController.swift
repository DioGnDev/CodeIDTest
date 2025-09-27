//
//  BaseTableViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import UIKit

open class BaseTableViewController: NiblessViewController {
  
  public var pagination: Paginateable = Pagination()
  
  public var items: [TableItemModel] = [] {
    didSet {
      registerCell()
      tableView.reloadData()
    }
  }
  
  public lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.delegate = self
    tv.dataSource = self
    tv.backgroundColor = .white
    tv.rowHeight = UITableView.automaticDimension
    tv.estimatedRowHeight = 60
    tv.showsVerticalScrollIndicator = false
    tv.alwaysBounceVertical = true
    tv.alwaysBounceHorizontal = false
    tv.showsHorizontalScrollIndicator = false
    tv.translatesAutoresizingMaskIntoConstraints = false
    //Register Cell
    tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return tv
  }()
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    prepareView()
    
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
  }
  
  public func registerCell(){
    let filtered = removeDuplicatedIdentifier()
    for item in filtered {
      tableView.register(item.type, forCellReuseIdentifier: item.identifier)
    }
  }
  
  private func removeDuplicatedIdentifier() -> [TableItemModel]{
    let shrinkItems = Set(items)
    return Array(shrinkItems)
  }
  
  open func fetchMoreData() { }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pagination.scrollViewDidScroll(
      scrollView: scrollView,
      height: tableView.contentSize.height
    ) {
      self.fetchMoreData()
    }
    
  }
  
  open func prepareView(){}
}

extension BaseTableViewController: UITableViewDataSource {
  
  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.item]
    let cell = dequeue(
      type: item.type,
      reuseIdentifier: item.identifier,
      cellForItemAt: indexPath
    ) as! ParentTableViewCell
    
    cell.setViewModel(item)
    
    return cell
  }
  
  open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}

extension BaseTableViewController: UITableViewDelegate {
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

extension BaseTableViewController {
  
  public func dequeue<T>(
    type: T.Type,
    reuseIdentifier: String,
    cellForItemAt indexPath: IndexPath
  ) -> UITableViewCell where T: UITableViewCell{
    
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    cell.selectionStyle = .none
    return cell
  }
  
}
