//
//  Navigation+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

/// Get the most recently presented UIViewController (visible)
public var currentController: UIViewController? {
    return getCurrentViewController()
}

/// Get the most recently presented UIViewController (visible)
/// - Parameter base: The base view controller to start searching for the child controllers, default is the `root view controller`
/// - Returns: Returns the most recently presented UIViewController (visible) if exists
public func getCurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

    if let nav = base as? UINavigationController {
        return getCurrentViewController(base: nav.visibleViewController)

    } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
        return getCurrentViewController(base: selected)

    } else if let presented = base?.presentedViewController {
        return getCurrentViewController(base: presented)
    }
    return base
}

//MARK: - Navigator
open class ESNavigator {
    
    /// Present the given screen
    /// - Parameters:
    ///   - screen: `Screen` object that contains the screen details
    ///   - controller: The controller that should be responsible for presenting this screen
    ///   - animated: Determine whether should animate the transition or not
    ///   - completion: A completion closure that fires after finishing the transition
    public static func goTo(_ screen: Screen, fromController controller: UIViewController? = currentController, animated: Bool = true, _ completion: (()->Void)? = nil) {
        guard let control = controller else { return }
        control.present(screen.storyboard.instantiateViewController(withIdentifier: screen.id) , animated: animated, completion: completion)
    }

    /// go to view controller and make it the root view
    ///
    /// - Parameter withId: the detination view controller id
    
    /// Change the root controller to the given screen
    /// - Parameters:
    ///   - screen: `Screen` object that contains the screen details
    ///   - animated: Determine whether should animate the transition or not
    ///   - completion: A completion closure that fires after finishing the transition
    public static func pushTo(_ screen: Screen, animated: Bool = true, _ completion: (()->Void)? = nil){
        guard let window = UIApplication.shared.keyWindow else {
            return Log.error("Couldn't get the current window")
        }
        
        window.rootViewController?.dismiss(animated: false, completion: nil)
        window.rootViewController = screen.storyboard.instantiateViewController(withIdentifier: screen.id)
        if animated {
            UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil) {
                _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
}

//MARK: - Screen
public extension ESNavigator {
    struct Screen {
        /// The screen id
        public var id: String
        
        /// The storyboard name that contains the screen, default is `Main`
        public var storyboardName: String = "Main"
        
        /// The bundle that contains the storyboard, default is `main bundle`
        public var bundle: Bundle? = nil
        
        var storyboard: UIStoryboard {
            return UIStoryboard(name: storyboardName, bundle: bundle)
        }
        
        
        /// Initialize a new `Screen` object
        /// - Parameters:
        ///   - id: The screen id
        ///   - storyboardName: The storyboard name that contains the screen, default is `Main`
        ///   - bundle: The bundle that contains the storyboard, default is `main bundle`
        public init (_ id: String, storyboardName: String = "Main", bundle: Bundle? = nil) {
            self.id = id
            self.storyboardName = storyboardName
            self.bundle = bundle
        }
    }
}
