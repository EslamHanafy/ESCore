//
//  WebViewController.swift
//  ESCore
//
//  Created by Eslam Hanafy on 3/15/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import WebKit
import RxSwift

open class WebViewController: UIViewController {
    @IBOutlet open var containerView: UIView!
    @IBOutlet open var loaderView: NVActivityIndicatorView!
    @IBOutlet open var titleLabel: UILabel!
    
    open var url: URL?
    open var screenTitle: String?
    
    open var webView: WKWebView!
    
    let refresher = UIRefreshControl()
    
    let bag = DisposeBag()
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        loaderView.startAnimating()
        initWebView()
        goTo(url)
        
        titleLabel.text = screenTitle
        titleLabel.font = Fonts.bold(ofSize: 20)
    }


    public static func show(with url: URL?, andTitle title: String, from controller: UIViewController?) {
        let screen = WebViewController(nibName: "WebViewController", bundle: currentBundle)
        screen.url = url
        screen.screenTitle = title
        screen.modalPresentationStyle = .fullScreen
        controller?.present(screen, animated: true, completion: nil)
    }
    
    
    
    //MARK: - IBActions
    @IBAction func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Helpers
extension WebViewController {
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
}

//MARK: - WebView
extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderView.stopAnimating()
        refresher.endRefreshing()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loaderView.stopAnimating()
        refresher.endRefreshing()
        Log.error("Eslam the webview error is: \(error.localizedDescription)")
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
