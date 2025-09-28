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
  let navigator: SignedInNavigator
  
  //Property
  var items: [PokeEntity] = []
  var filteredItems: [PokeEntity] = []
  var isLoading: Bool = false
  
  //State
  private let disposeBag = DisposeBag()
  
  //Views
  private var footerView: LoadingFooterView!
  
  lazy var searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: nil)
    sc.searchBar.placeholder = "Search pokemon name here"
    sc.searchBar.sizeToFit()
    sc.searchBar.searchBarStyle = .prominent
    return sc
  }()
  
  lazy var tableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.dataSource = self
    tv.delegate = self
    tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tv.backgroundColor = .white
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.tableFooterView = footerView
    tv.tableHeaderView = searchBar
    return tv
  }()
  
  private lazy var searchBar: UISearchBar = {
    let sb = UISearchBar()
    sb.placeholder = "Search Pokémon"
    sb.sizeToFit()
    return sb
  }()
  
  public init(useCase: ListUseCase, navigator: SignedInNavigator) {
    self.useCase = useCase
    self.navigator = navigator
    
    super.init()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.titleView = searchBar
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    print("current_vc: - \(self.self)")
    
    view.backgroundColor = .clear
    
    setupView()
    
    observe()
    
    isLoading = true
    useCase.loadItems()
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] item in
        guard let self = self else { return }
        items = item
        filteredItems = items
        tableView.reloadData()
        isLoading = false
      }.disposed(by: disposeBag)
    
  }
  
  private func setupView() {
    footerView = LoadingFooterView(frame: .init(x: 0, y: 0, width: tableView.bounds.width, height: 60))
    tableView.tableFooterView = footerView
    footerView.stopLoading()
    
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
        isLoading = true
        
        useCase.loadMore()
          .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
          .observe(on: MainScheduler.instance)
          .subscribe { [weak self] item in
            guard let self = self else { return }
            items.append(contentsOf: item)
            filteredItems = items
            footerView.stopLoading()
            isLoading = false
            tableView.reloadData()
          }.disposed(by: disposeBag)
      }
    }
  }
  
  private func observe() {
    searchBar.rx.text.orEmpty
      .map { $0.lowercased() }
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: {  [weak self] searchTxt in
        guard let self = self else { return }
        filteredItems = searchTxt.isEmpty ? items : items.filter { $0.name.contains(searchTxt) }
        tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
  
  public func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
    return "Pokemon"
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
    return filteredItems.count
  }
  
  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    let item = filteredItems[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = item.name
    
    return cell
  }
  
  public func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let selectedEntity = filteredItems[indexPath.row]
    navigator.navigateToDetail(name: selectedEntity.name)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  public func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    
    if tableView.contentSize.height < tableView.bounds.height {
      if !isLoading {
        isLoading = true
        useCase.loadMore()
          .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
          .observe(on: MainScheduler.instance)
          .subscribe { [weak self] item in
            guard let self = self else { return }
            items.append(contentsOf: item)
            filteredItems = items
            footerView.stopLoading()
            isLoading = false
            tableView.reloadData()
          }.disposed(by: disposeBag)
      }
    }
  }
  
}
