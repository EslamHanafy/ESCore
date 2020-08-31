//
//  ConnectivityManager.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import Connectivity
import RxSwift

open class ConnectivityManager: NSObject {
    public static let shared: ConnectivityManager = ConnectivityManager()
    
    private var connectivity: Connectivity = Connectivity()
    private var connectionDisposable = Disposables.create()
    
    public var isConnected: Observable<Bool> {
        connectivity.rx.isConnected
    }
    
    var view: DisConnectedView? = nil
    
    var lastStatus: Connectivity.Status = .connected
    
    
    private override init() {
        super.init()
    }
    
    public func startMonitor() {
        connectivity.startNotifier()
        connectionDisposable = connectivity.rx.status.subscribe(onNext: {
            [weak self] status in
            guard let self = self else { return }
            Log.debug("The new internet status is: \(status)")
            switch status {
            case .connected, .connectedViaCellular, .connectedViaWiFi:
                if self.lastStatus != .connected && self.lastStatus != .connectedViaCellular && self.lastStatus != .connectedViaWiFi {
                    "internetConnected".selfLocalized.displayLocalized()
                }
            
            default:
                "noInternet".selfLocalized.displayLocalized()
            }
            self.lastStatus = status
        })
    }
    
    public func stopMonitor() {
        connectivity.stopNotifier()
        connectionDisposable.dispose()
    }
}

//MARK: - Helpers
private extension ConnectivityManager {
    func showDisconnectedView() {
        let window = UIApplication.shared.keyWindow!
        view = DisConnectedView.getInstance(for: self)
        view!.frame = window.frame
        view!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(view!)
        window.bringSubviewToFront(view!)
        view!.fadeTransition(withDuration: 0.5)
    }
    
    func hideDisconnectedView() {
        guard view?.isHidden == false else { return }
        view!.isHidden = true
        view!.removeFromSuperview()
        view = nil
    }
}
