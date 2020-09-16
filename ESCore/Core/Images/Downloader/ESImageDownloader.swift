//
//  ESImageDownloader.swift
//  EslamCore
//
//  Created by Eslam on 11/3/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import SDWebImage

open class ESImageDownloader {
    
    open class func download(_ url: URL?, showLoader: Bool = false, _ onComplete: @escaping (_ image: UIImage?, _ error: Error?)->()) {
        if showLoader { mainQueue { ESCore.loaderView.show() } }
        
        let request = SDWebImageManager.shared.loadImage(with: url, progress: { (receivedSize, expectedSize, _) in
            mainQueue {
                ESCore.loaderView.update(progress: Float(receivedSize / expectedSize))
            }
        }) { (image, data, error, _, _, _) in
            if showLoader { ESCore.loaderView.hide() }
            if let image = image {
                onComplete(image, nil)
            }else {
                onComplete(nil, error)
            }
        }
        
        if showLoader { mainQueue { ESCore.loaderView.imageOperation = request } }
    }
}
