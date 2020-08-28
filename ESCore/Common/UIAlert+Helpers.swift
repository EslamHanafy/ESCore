//
//  UIAlert+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit


public func displayAlert(withTitle tile: String? = nil, andMesseg message: String? = nil, fromController controller: UIViewController? = nil){
    guard let controller = controller ?? currentController else {
        return
    }
    
    let alert = UIAlertController(title: tile, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "ok".selfLocalized, style: UIAlertAction.Style.default, handler: nil))
    
    DispatchQueue.main.async(execute: {
        controller.present(alert, animated: true, completion: nil)
    })
}

public func displayConfirmationAlert(withTitle title: String? = nil, andMessage message: String? = nil, fromController controller: UIViewController? = currentController, onConfirm: @escaping ()->()) {
    
    guard let controller = controller ?? currentController else {
        return
    }
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "yes".selfLocalized, style: .destructive, handler: { (_) in
        onConfirm()
    }))
    alert.addAction(UIAlertAction(title: "no".selfLocalized, style: .cancel, handler: nil))
    
    controller.present(alert, animated: true, completion: nil)
}

public func displayErrorAlert(withTitle title: String? = nil, andMessage message: String? = "unknownError".selfLocalized, fromController controller: UIViewController? = currentController, onComplete: @escaping ()->()) {
    
    guard let controller = controller ?? currentController else {
    return
    }
    
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "tryAgain".selfLocalized, style: .default, handler: { (_) in
        onComplete()
    }))
    
    controller.present(alert, animated: true, completion: nil)
}

//MARK: - Menus
typealias UIMenu = UIAlertController
public extension UIAlertController {
    static func menu(withTitle title: String? = nil,
                     andMessage message: String? = nil, forSourceView view: UIView) -> UIAlertController {
        view.superview?.layoutIfNeeded()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect =
            CGRect(x: view.frame.midX, y: view.frame.maxY,
                   width: view.frame.width, height: view.frame.height)
        alert.addAction(UIAlertAction.cancelAction())
        return alert
    }
    
    static func localizedMenu(withTitle title: String? = nil,
                              andMessage message: String? = nil,
                              forSourceView view: UIView) -> UIAlertController {
        return menu(withTitle: title?.localized, andMessage: message?.localized, forSourceView: view)
    }
    
    /// Creates a `UIAlertController` with a custom `UIView` instead the message text.
    /// - Note: In case anything goes wrong during replacing the message string with the custom view, a fallback message will
    /// be used as normal message string.
    ///
    /// - Parameters:
    ///   - title: The title text of the alert controller
    ///   - customView: A `UIView` which will be displayed in place of the message string.
    ///   - fallbackMessage: An optional fallback message string, which will be displayed in case something went wrong with inserting the custom view.
    ///   - preferredStyle: The preferred style of the `UIAlertController`.
    convenience init(title: String?, customView: UIView, fallbackMessage: String? = nil, preferredStyle: UIAlertController.Style) {

        let marker = "__CUSTOM_CONTENT_MARKER__"
        self.init(title: title, message: marker, preferredStyle: preferredStyle)

        // Try to find the message label in the alert controller's view hierarchie
        if let customContentPlaceholder = self.view.findLabel(withText: marker),
            let customContainer =  customContentPlaceholder.superview {

            // The message label was found. Add the custom view over it and fix the autolayout...
            customContainer.addSubview(customView)

            customView.translatesAutoresizingMaskIntoConstraints = false
            customContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[customView]-|", options: [], metrics: nil, views: ["customView": customView]))
            customContainer.addConstraint(NSLayoutConstraint(item: customContentPlaceholder,
                                                             attribute: .top,
                                                             relatedBy: .equal,
                                                             toItem: customView,
                                                             attribute: .top,
                                                             multiplier: 1,
                                                             constant: 0))
            customContainer.addConstraint(NSLayoutConstraint(item: customContentPlaceholder,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: customView,
                                                             attribute: .height,
                                                             multiplier: 1,
                                                             constant: 0))
            customContentPlaceholder.text = ""
        } else { // In case something fishy is going on, fall back to the standard behaviour and display a fallback message string
            self.message = fallbackMessage
        }
    }
}

public extension UIAlertAction {
    static func cancelAction(_ title: String? = nil) -> UIAlertAction {
        return UIAlertAction(title: title ?? "cancel".selfLocalized, style: .cancel, handler: nil)
    }
}
