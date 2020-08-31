//
//  Navigation+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

// Returns the most recently presented UIViewController (visible)
public var currentController: UIViewController? {
    // we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    
    return nil
}

public func goToView(atStoryboard story: String = "Main", withId id:String, fromController controller:UIViewController? = nil) {
    guard let control = controller ?? currentController else { return }
    let board = UIStoryboard(name: story, bundle: nil)
    control.present(board.instantiateViewController(withIdentifier: id) , animated: true, completion: nil)
}

/// go to view controller and make it the root view
///
/// - Parameter withId: the detination view controller id
public func pushToView(withId id:String, _ onComplete: (()->())? = nil){
    let window: UIWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.delegate!.window!!
    window.rootViewController?.dismiss(animated: false, completion: nil)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    window.rootViewController = storyboard.instantiateViewController(withIdentifier: id)
    UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil) {
        _ in
        onComplete?()
    }
}
