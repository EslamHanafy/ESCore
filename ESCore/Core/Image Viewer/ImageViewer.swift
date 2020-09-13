//
//  ImageViewer.swift
//  EslamCore
//
//  Created by Eslam on 11/3/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import ImageSlideshow

open class ImageViewer {
    public class func show(_ image: UIImage?, from controller: UIViewController? = currentController) {
        if image == nil { return }
        
        show([image], from: controller)
    }
    
    public class func show(_ images: [UIImage?], startingAt index: Int = 0, from controller: UIViewController? = currentController) {
        
        let items = images.unwrap().map({
            ImageSource(image: $0)
        })
        
        guard items.count > 0 else { return }
        
        display(items, startingAt: index, from: controller)
    }
    
    public class func show(_ url: URL?, withPlaceholder placeholder: UIImage? = nil, from controller: UIViewController? = currentController) {
        if url == nil { return }
        
        show([url], withPlaceholder: placeholder, from: controller)
    }
    
    public class func show(_ urls: [URL?], startingAt index: Int = 0, withPlaceholder placeholder: UIImage? = nil, from controller: UIViewController? = currentController) {
        
        let items = urls.unwrap().map({
            SDWebImageSource(url: $0, placeholder: placeholder)
        })
        
        guard items.count > 0 else { return }
        
        display(items, startingAt: index, from: controller)
    }
    
    private class func display(_ data: [InputSource], startingAt index: Int = 0, from controller: UIViewController?) {
        
        guard let controller = controller else {
            return
        }
        
        let view = ImageSlideshow()
        view.setImageInputs(data)
        view.zoomEnabled = true
        view.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        view.setCurrentPage(index, animated: true)
        view.presentFullScreenController(from: controller)
    }
}
