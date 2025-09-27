//
//  PokeListViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 27/09/25.
//

import Foundation
import UIKit
import RxSwift

public class PokeListViewController: NiblessViewController {
  
  //Dependency
  let useCase: ListUseCase
  
  //Property
  var items: [PokeItem] = []
  var currentPage: Int = 0
  
  private let disposeBag = DisposeBag()
  
  lazy var tableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.dataSource = self
    tv.delegate = self
    tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tv.backgroundColor = .white
    tv.translatesAutoresizingMaskIntoConstraints = false
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
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] item in
        self?.items = item
        self?.tableView.reloadData()
      }.disposed(by: disposeBag)
  }
  
  private func setupView() {
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
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
  
}
