//
//  ESImageViewer.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/3/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import Agrume

open class ESImageViewer {
    public static let shared: ESImageViewer = ESImageViewer()
    
    let closeButton: UIBarButtonItem?
    
    
    public init() {
        AgrumeServiceLocator.shared.setDownloadHandler { (url, completion) in
            ESImageDownloader.download(url) { (image, error) in
                if let error = error { Log.error("The error in dowloding image from: \(url.absoluteString) is: \(error.localizedDescription)") }
                mainQueue {
                    completion(image)
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
        } else {
            closeButton = nil
        }
    }
    
    
    
    
    public func show(_ image: UIImage?, background: Background = .blurred(.extraLight), from controller: UIViewController? = currentController) {
        guard let image = image, let controller = controller else { return }
        let agrume = Agrume(image: image, background: background, dismissal: .withPhysicsAndButton(closeButton))
        agrume.show(from: controller)
    }
    
    
    public func show(_ images: [UIImage?], startingAt index: Int = 0, background: Background = .blurred(.extraLight), from controller: UIViewController? = currentController) {
        let items = images.unwrap()
        guard let controller = controller, items.count > 0 else { return }
        
        let agrume = Agrume(images: items, startIndex: index, background: background, dismissal: .withPhysicsAndButton(closeButton))
        agrume.show(from: controller)
    }
    
    public func show(_ url: URL?, withPlaceholder placeholder: UIImage? = nil, background: Background = .blurred(.extraLight), from controller: UIViewController? = currentController) {
        guard let url = url, let controller = controller else { return }
        let agrum = Agrume(url: url, background: background, dismissal: .withPhysicsAndButton(closeButton))
        agrum.show(from: controller)
    }
    
    public func show(_ urls: [URL?], startingAt index: Int = 0, withPlaceholder placeholder: UIImage? = nil, background: Background = .blurred(.extraLight), from controller: UIViewController? = currentController) {
        let items = urls.unwrap()
        guard let controller = controller, items.count > 0 else { return }
        let agrume = Agrume(urls: items, startIndex: index, background: background, dismissal: .withPhysicsAndButton(closeButton))
        agrume.show(from: controller)
    }
}
