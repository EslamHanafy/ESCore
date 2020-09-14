//
//  ESConnectivityManager.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import Connectivity
import RxSwift

open class ESConnectivityManager: NSObject {
    public static let shared: ESConnectivityManager = ESConnectivityManager()
    
    private var connectivity: Connectivity = Connectivity()
    
    private var disconnectView: DisConnectedView? = nil
    
    public var connectionDisposable = Disposables.create()
    
    public var isConnectedObservable: Observable<Bool> {
        connectivity.rx.isConnected
    }
    
    public var isConnected: Bool  {
        return connectivity.isConnected
    }
    
    public var settings: ESConnectivitySettings = ESConnectivitySettings()
    
    public var alertType: AlertType {
        return settings.alertType
    }
    
    
    public private(set) var lastStatus: Connectivity.Status = .connected
    public private(set) var isDisplayingDisconnectView: Bool = false
    
    
    private override init() {
        super.init()
    }
    
    
    
    public func startMonitor(with settings: ESConnectivitySettings = ESConnectivitySettings()) {
        connectivity.startNotifier()
        self.settings = settings
        
        connectionDisposable = connectivity.rx.status.distinctUntilChanged().observeOn(MainScheduler.asyncInstance).subscribe(onNext: {
            [weak self] status in
            guard let self = self else { return }
            self.updateConnectionStatus(status)
        })
    }
    
    public func stopMonitor() {
        connectivity.stopNotifier()
        connectionDisposable.dispose()
    }
    
    public func checkConnectivity(onComplete: ((_ status: Connectivity.Status)-> Void)? = nil) {
        connectivity.checkConnectivity() {
            [weak self] con in
            mainQueue {
                onComplete?(con.status)
                self?.updateConnectionStatus(con.status)
            }
        }
    }
}

//MARK: - Helpers
private extension ESConnectivityManager {
    func updateConnectionStatus(_ status: Connectivity.Status) {
        Log.debug("The new internet status is: \(status)")
        
        switch status {
        case .connected, .connectedViaCellular, .connectedViaWiFi:
            if self.lastStatus != .connected && self.lastStatus != .connectedViaCellular && self.lastStatus != .connectedViaWiFi {
                self.displayConnectedAler()
            }
        
        default:
            self.displayNoInternetAlert()
        }
        
        self.lastStatus = status
    }
    
    func displayConnectedAler() {
        switch alertType {
        case .message:
            settings.connectedAlert.displayLocalized()
        
        default:
            hideDisconnectedView()
        }
    }
    
    func displayNoInternetAlert() {
        switch alertType {
        case .message:
            settings.disconnectedAlert.displayLocalized()
            
        default:
            showDisconnectedView()
        }
    }
    
    func showDisconnectedView() {
        guard !isDisplayingDisconnectView && disconnectView == nil else {
            return
        }
        
        let window = UIApplication.shared.keyWindow!
        disconnectView = DisConnectedView.getInstance(for: self)
        disconnectView!.configure(with: settings)
        
        disconnectView!.frame = window.frame
        disconnectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        window.addSubview(disconnectView!)
        window.bringSubviewToFront(disconnectView!)
        
        disconnectView!.fadeTransition(withDuration: 0.5)
        isDisplayingDisconnectView = true
    }
    
    func hideDisconnectedView() {
        guard disconnectView?.isHidden == false else { return }
        disconnectView!.isHidden = true
        disconnectView!.removeFromSuperview()
        disconnectView = nil
        isDisplayingDisconnectView = false
    }
}

//MARK: - Alert Type
public extension ESConnectivityManager {
    enum AlertType {
        case message
        case fullscreenWithImage
        case fullscreenWithGIFImage
    }
}
