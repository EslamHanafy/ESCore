//
//  Common.swift
//  EslamCore
//
//  Created by Eslam on 12/01/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import SystemConfiguration


public let Log = ESLogger.shared

public var screenWidth:CGFloat { get { return UIScreen.main.bounds.size.width } }
public var screenHeight:CGFloat { get { return UIScreen.main.bounds.size.height } }
public var isIpad: Bool { return UIScreen.main.traitCollection.horizontalSizeClass == .regular }
public var isRTL: Bool { return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft }
public var language: String { return isRTL ? "ar" : "en" }


public var currentDate: String {
    let format = DateFormatter()
    format.dateFormat = "dd-MM-yyyy-hh:mm:ss"
    format.locale = Locale(identifier: "en")
    let date = format.string(from: Date())
    return date
}

public var isConnectedToNetwork: Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}



//MARK: - Methods

/// share items like string or images to all available social media
///
/// - Parameters:
///   - items: the items to share
///   - controller: the controller that will be responsable for displaying the ActivityController
///   - types: the excluded activity types, default value is nil
public func share(items:[Any], forController controller:UIViewController, excludedActivityTypes types:[UIActivity.ActivityType]? = nil) {
    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
    
    // exclude some activity types from the list (optional)
    activityViewController.excludedActivityTypes = types
    
    // present the view controller
    controller.present(activityViewController, animated: true, completion: nil)
}

public func bundle(for object: AnyObject) -> Bundle {
    return Bundle(for: type(of: object))
}

public func print_properties(ofObject object: Any) {
    let mirrored_object = Mirror(reflecting: object)
    for (index, attr) in mirrored_object.children.enumerated() {
        if let property_name = attr.label {
            print(" Attr \(index): \(property_name) = \(attr.value)")
        }
    }
}

public func displayForceAlert() {
    let alert = UIAlertController(title: "oldVersion".selfLocalized, message: "oldVersionMessage".selfLocalized, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "update".selfLocalized, style: .default, handler: { (_) in
//        APIConstants.appUrl.url?.open()
//    }))
    currentController?.present(alert, animated: true, completion: nil)
}
