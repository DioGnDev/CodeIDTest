//
//  Reachability.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 28/09/25.
//


import Network
import RxSwift

final class Reachability {
  static let shared = Reachability()
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "Reachability")
  private let subject = BehaviorSubject<Bool>(value: true)
  
  var isOnline: Observable<Bool> { subject.asObservable().distinctUntilChanged() }
  
  private init() {
    monitor.pathUpdateHandler = { [subject] path in
      subject.onNext(path.status == .satisfied)
    }
    monitor.start(queue: queue)
  }
}
