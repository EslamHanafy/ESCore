//
//  ESWebViewController.swift
//  ESCore
//
//  Created by Eslam Hanafy on 3/15/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import WebKit
import RxSwift

open class ESWebViewController: UIViewController {
    @IBOutlet open var containerView: UIView!
    @IBOutlet open var loaderView: NVActivityIndicatorView!
    @IBOutlet open var titleLabel: ESLabel!
    @IBOutlet open var headerView: UIView!
    
    open var url: URL?
    open var screenTitle: String?
    
    open var webView: WKWebView!
    
    open var settings: Settings = Settings() {
        didSet {
            applySettings()
        }
    }
    
    private var didLoadView: Bool = false
    
    
    let refresher = UIRefreshControl()
    
    let bag = DisposeBag()
    
    
    public static var defaultSettings: Settings = Settings()
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        didLoadView = true

        loaderView.startAnimating()
        initWebView()
        goTo(url)
        
        titleLabel.text = screenTitle
        
        applySettings()
    }


    public static func show(with url: URL?, andTitle title: String, withSettings settings: Settings = ESWebViewController.defaultSettings, from controller: UIViewController?) {
        let screen = ESWebViewController(nibName: "WebViewController", bundle: currentBundle)
        screen.url = url
        screen.screenTitle = title
        screen.settings = settings
        screen.modalPresentationStyle = .fullScreen
        controller?.present(screen, animated: true, completion: nil)
    }
    
    
    
    //MARK: - IBActions
    @IBAction func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Helpers
extension ESWebViewController {
    @objc func reloadPage() {
        webView.reload()
    }
    
    public func goTo(_ url: URL?) {
        guard let url = url else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func addWebViewConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addConstraint(NSLayoutConstraint(item: webView!, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: webView!, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: webView!, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: webView!, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        self.view.layoutIfNeeded()
    }
    
    public func applySettings() {
        guard didLoadView else {
            return
        }
        
        self.view.backgroundColor = settings.backgroundColor
        self.headerView.backgroundColor = settings.headerColor
        self.containerView.backgroundColor = settings.containerColor
        self.loaderView.color = settings.loaderColor
        self.titleLabel.textColor = settings.titleColor
        self.titleLabel.font = settings.titleFont
    }
}

//MARK: - WebView
extension ESWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderView.stopAnimating()
        refresher.endRefreshing()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loaderView.stopAnimating()
        refresher.endRefreshing()
        Log.error("The webview error is: \(error.localizedDescription)")
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loaderView.startAnimating()
    }
    
    private func initWebView() {
        self.view.layoutIfNeeded()
        
//        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//
//        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        let wkUController = WKUserContentController()
//        wkUController.addUserScript(userScript)
//        let wkWebConfig = WKWebViewConfiguration()
//        wkWebConfig.userContentController = wkUController
        webView = WKWebView(frame: containerView.bounds)
        webView.navigationDelegate = self
        webView.scrollView.sizeToFit()
        containerView.addSubview(webView)
        
        addWebViewConstraints()
        
        webView.scrollView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(self.reloadPage), for: .valueChanged)
    }
}

//MARK: - Settings
public extension ESWebViewController {
    struct Settings {
        public var backgroundColor: UIColor = .black
        public var headerColor: UIColor = "262626".colorValue
        public var containerColor: UIColor = .white
        public var loaderColor: UIColor = .white
        public var titleColor: UIColor = .white
        public var titleFont: UIFont = Fonts.bold(ofSize: 20)
    }
}
