//
//  DeviceRaisedToEarListener.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/11/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import CoreMotion
import UIKit

class DeviceRaisedToEarListener: NSObject {
    private let deviceQueue = OperationQueue()
    private let motionManager = CMMotionManager()
    private var vertical: Bool = false
    
    private(set) var isRaisedToEar: Bool = false {
        didSet {
            if oldValue != self.isRaisedToEar {
                self.stateChanged?(self.isRaisedToEar)
            }
        }
    }
    
    var stateChanged:((_ isRaisedToEar: Bool)->())? = nil
    
    override init() {
        super.init()
        self.setupMotionManager()
    }
    
    private func setupMotionManager() {
        self.motionManager.deviceMotionUpdateInterval = 5.0 / 60.0
        
        // Only listen for proximity changes if the device is held vertically
        self.motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical, to: self.deviceQueue) { (motion, error) in
            self.vertical = (motion!.gravity.z > -0.4 && motion!.gravity.z < 0.4 && motion!.gravity.y < -0.7)
        }
    }
    
    func startListening() {
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleProximityChange(notification:)), name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }
    
    func stopListening() {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleProximityChange(notification: NSNotification) {
        self.isRaisedToEar = UIDevice.current.proximityState && self.vertical
    }
    
    deinit {
        self.stopListening()
    }
}
