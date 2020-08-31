//
//  UIView+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

public extension UIView {
    /// Take screenshot of view (if applicable).
    var screenshoot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var snapshotView: UIView {
        let image = self.screenshoot
        let viewSnapshot = UIImageView(image: image)
        viewSnapshot.layer.masksToBounds = false
        viewSnapshot.layer.cornerRadius = 0.0
        viewSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        viewSnapshot.layer.shadowRadius = 5.0
        viewSnapshot.layer.shadowOpacity = 0.4
        return viewSnapshot
    }
    
    
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
    
    /// Find the first responder view (UITexView, UITextField ..) in this view
    func findFirstResponder() -> UIView? {
        for subView in self.subviews {
            if subView.isFirstResponder {
                return subView
            }
            
            if let recursiveSubView =  subView.findFirstResponder() {
                return recursiveSubView
            }
        }
        
        return nil
    }
    
    func fadeTransition(withDuration duration: TimeInterval = 0.35) {
        let trans = CATransition()
        trans.duration = duration
        trans.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        trans.type = .fade
        self.layer.add(trans, forKey: nil)
    }
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    
    
    /// Searches a `UILabel` with the given text in the view's subviews hierarchy.
    ///
    /// - Parameter text: The label text to search
    /// - Returns: A `UILabel` in the view's subview hierarchy, containing the searched text or `nil` if no `UILabel` was found.
    func findLabel(withText text: String) -> UILabel? {
        if let label = self as? UILabel, label.text == text {
            return label
        }

        for subview in self.subviews {
            if let found = subview.findLabel(withText: text) {
                return found
            }
        }

        return nil
    }
    
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
    func subView<T: UIView>(of type: T.Type) -> T? {
        return subviews.first(where: { $0 is T }) as? T
    }
    
    func showHideAnimation(show: Bool, withDuration duration: TimeInterval = 0.5, _ onComplete: (()->Void)? = nil) {
        if show {
            guard isHidden else { return Log.warning("Trying to show a displayed view: \(self)") }
            
            self.alpha = 0.0
            self.isHidden = false

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.alpha = 1.0
            }) { (isCompleted) in
                onComplete?()
            }
        } else{
            guard !isHidden else { return Log.warning("Trying to hide a hidden view: \(self)") }
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.alpha = 0.0
            }) { [weak self] (isCompleted) in
                self?.isHidden = true
                self?.alpha = 1.0
                onComplete?()
            }
        }
    }
}
