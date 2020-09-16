//
//  ESLoaderView.swift
//  EslamCore
//
//  Created by Eslam on 11/14/16.
//  Copyright © 2016 Eslam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SDWebImage

typealias LoaderView = ESLoaderView

open class ESLoaderView: UIView {
    public static let shared: ESLoaderView = ESLoaderView.getInstance()
    
    @IBOutlet open var loader: NVActivityIndicatorView!
    @IBOutlet open var titleLabel: UILabel!
    @IBOutlet open var progressView: UIProgressView!
    
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
    
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        let color = UIApplication.shared.keyWindow?.tintColor ?? .white
        loader.color = color
        titleLabel.textColor = color
        progressView.progressTintColor = color
    }
    
    
    /// get new instance from ESLoaderView and add it to the main window
    ///
    /// - Returns: new ESLoaderView
    fileprivate static func getInstance() -> ESLoaderView {
        let window = (UIApplication.shared.delegate!.window!)!
        
        let view = currentBundle.loadNibNamed("LoaderView", owner: window, options: nil)?.first as! ESLoaderView
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

//MARK: - ESLoaderType
extension ESLoaderView: ESLoaderType {
    public func show() {
        show(withTitle: nil)
    }
    
    public func show(withTitle title: String?) {
        mainQueue {
            [weak self] in
            guard let self = self else { return }
            if let title = title {
                self.titleLabel.text = title
                self.titleLabel.isHidden = false
            }else {
                self.titleLabel.isHidden = true
            }
            
            if self.isHidden {
                UIApplication.shared.keyWindow?.bringSubviewToFront(self)
                self.isHidden = false
                self.loader.startAnimating()
            }
        }
    }
    
    public func show(with request: Request? = nil, andTitle title: String? = nil) {
        self.request = request
        show(withTitle: title)
    }
    
    public func hide() {
        guard !self.isHidden else { return }
        mainQueue {
            [weak self] in
            guard let self = self else { return }
            self.cancelRequests()
            UIApplication.shared.keyWindow?.sendSubviewToBack(self)
            self.progressView.isHidden = true
            self.titleLabel.isHidden = true
            self.titleLabel.text = ""
            self.isHidden = true
            self.loader.stopAnimating()
        }
    }
    
    public func comeToWindowIfNeeded() {
        mainQueue { [weak self] in
            guard let self = self else { return }
            if !self.isHidden {
                UIApplication.shared.keyWindow?.bringSubviewToFront(self)
            }
        }
    }
    
    public func update(progress: Float) {
        mainQueue { [weak self] in
            guard let self = self else { return }
            if self.progressView.isHidden == true {
                self.progressView.isHidden = false
            }
            
            self.progressView.progress = progress
        }
    }
    
    public func cancelRequests() {
        self.request?.cancel()
        request = nil
        imageOperation = nil
        ESLoaderView.onCancel = nil
    }
}

//MARK: - Show/Hide Options
public extension ESLoaderView {
    static func show(with request: Request?, andTitle title: String? = nil) {
        shared.show(with: request, andTitle: title)
    }
    
    
    static func show(withTitle title: String? = nil) {
        shared.show(withTitle: title)
    }
    
    
    /// hide the loader view
    static func hide() {
        shared.hide()
    }
}

//MARK: - Helpers
public extension ESLoaderView {
    static func comeToWindowIfNeeded() {
        shared.comeToWindowIfNeeded()
    }
    
    static func update(progress: Float) {
        shared.update(progress: progress)
    }
    
    /// display cancel request confirmation alert
    fileprivate func displayConfirmationAlert() {
        let alert = UIAlertController(title: "cancel".selfLocalized, message: "cancelRequest".selfLocalized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "yes".selfLocalized, style: .destructive, handler: { (_) in
            ESLoaderView.onCancel?()
            ESLoaderView.hide()
        }))
        
        alert.addAction(UIAlertAction(title: "no".selfLocalized, style: .cancel, handler: { (_) in
            UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        }))
        
        UIApplication.shared.keyWindow?.sendSubviewToBack(self)
        currentController?.present(alert, animated: true, completion: nil)
    }
}
