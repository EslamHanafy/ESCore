//
//  LoaderView.swift
//  EslamCore
//
//  Created by Eslam on 11/14/16.
//  Copyright © 2016 Eslam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SDWebImage

open class LoaderView: UIView {
    public static let shared: LoaderView = LoaderView.getInstance()
    
    @IBOutlet var loader: NVActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    
    open var request: Request? {
        didSet {
            if self.isHidden { request = nil }
        }
    }
    
    open var imageOperation: SDWebImageCombinedOperation? {
        didSet {
            if self.isHidden { imageOperation = nil }
        }
    }
    
    public static var request: Request? {
        get { return shared.request }
        set { shared.request = newValue }
    }
    
    public static var onCancel: (()->())?
    
    
    
    /// get new instance from LoaderView and add it to the main window
    ///
    /// - Returns: new LoaderView
    fileprivate static func getInstance() -> LoaderView {
        let window = (UIApplication.shared.delegate!.window!)!
        
        let view = currentBundle.loadNibNamed("LoaderView", owner: window, options: nil)?.first as! LoaderView
        view.frame = window.frame
        view.isHidden = true
        view.progressView.isHidden = true
        window.addSubview(view)
        return view
    }
    
    
    //MARK: - IBAction
    @IBAction func cancelAction() {
        displayConfirmationAlert()
    }
}

//MARK: - Show/Hide Options
public extension LoaderView {
    static func show(with request: Request?, andTitle title: String? = nil) {
        shared.request = request
        show(withTitle: title)
    }
    
    
    static func show(withTitle title: String? = nil) {
        mainQueue {
            if let title = title {
                shared.titleLabel.text = title
                shared.titleLabel.isHidden = false
            }else {
                shared.titleLabel.isHidden = true
            }
            
            if shared.isHidden {
                UIApplication.shared.keyWindow?.bringSubviewToFront(shared)
                shared.isHidden = false
                shared.loader.startAnimating()
            }
        }
    }
    
    
    /// hide the loader view
    static func hide() {
        guard !shared.isHidden else { return }
        mainQueue {
            shared.cancelRequests()
            UIApplication.shared.keyWindow?.sendSubviewToBack(LoaderView.shared)
            shared.progressView.isHidden = true
            shared.titleLabel.isHidden = true
            shared.titleLabel.text = ""
            shared.isHidden = true
            shared.loader.stopAnimating()
        }
    }
}

//MARK: - Helpers
public extension LoaderView {
    static func comeToWindowIfNeeded() {
        if !shared.isHidden {
            UIApplication.shared.keyWindow?.bringSubviewToFront(LoaderView.shared)
        }
    }
    
    static func update(progress: Float) {
        if shared.progressView.isHidden == true {
            shared.progressView.isHidden = false
        }
        
        shared.progressView.progress = progress
    }
    
    /// display cancel request confirmation alert
    fileprivate func displayConfirmationAlert() {
        let alert = UIAlertController(title: "cancel".selfLocalized, message: "cancelRequest".selfLocalized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "yes".selfLocalized, style: .destructive, handler: { (_) in
            LoaderView.onCancel?()
            LoaderView.hide()
        }))
        
        alert.addAction(UIAlertAction(title: "no".selfLocalized, style: .cancel, handler: { (_) in
            UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        }))
        
        UIApplication.shared.keyWindow?.sendSubviewToBack(self)
        currentController?.present(alert, animated: true, completion: nil)
    }
    
    func cancelRequests() {
        self.request?.cancel()
        request = nil
        imageOperation = nil
        LoaderView.onCancel = nil
    }
}
