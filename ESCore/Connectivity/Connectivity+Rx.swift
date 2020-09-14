//
//  Connectivity+Rx.swift
//  EslamCore
//
//  Created by Eslam on 10/12/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import Connectivity
import RxSwift

//MARK: - static methods
public extension Reactive where Base: Connectivity {
    static var connectivityChanges: Observable<Connectivity> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.ConnectivityDidChange).flatMap {
                (notification) -> Observable<Connectivity> in
                if let connectivity = notification.object as? Connectivity {
                    return .just(connectivity)
                }
                return .empty()
        }
    }
    
    static var status: Observable<Connectivity.Status> {
        return connectivityChanges.map({ $0.status })
    }
    
    static var isReachable: Observable<Bool> {
        return connectivityChanges
            .map({ $0.status != .notConnected && $0.status != .determining })
    }
    
    static var isConnected: Observable<Bool> {
        return connectivityChanges.map({ $0.isConnected })
    }
    
    static var isDisconnected: Observable<Bool> {
        return connectivityChanges.map({ !$0.isConnected })
    }
}

//MARK: -  instanse methods
public extension Reactive where Base: Connectivity {
    var connectivityChanges: Observable<Connectivity> {
        return NotificationCenter.default.rx
            .notification(Notification.Name.ConnectivityDidChange, object: base)
            .flatMap {
                (notification) -> Observable<Connectivity> in
                if let connectivity = notification.object as? Connectivity {
                    return .just(connectivity)
                }
                return .empty()
        }
    }
    
    var status: Observable<Connectivity.Status> {
        return connectivityChanges.map({ $0.status })
    }
    
    var isReachable: Observable<Bool> {
        return connectivityChanges
            .map({ $0.status != .notConnected && $0.status != .determining })
    }
    
    var isConnected: Observable<Bool> {
        return connectivityChanges.map({ $0.isConnected })
    }
    
    var isDisconnected: Observable<Bool> {
        return connectivityChanges.map({ !$0.isConnected })
    }
}
