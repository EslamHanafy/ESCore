//
//  ImageDownloader.swift
//  EslamCore
//
//  Created by Eslam on 11/3/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import SDWebImage

open class ImageDownloader {
    open var url: URL?
    
    public init(_ url: URL?) {
        self.url = url
    }
    
    public func download(showLoader: Bool = false, _ onComplete: @escaping (_ image: UIImage?, _ error: Error?)->()) {
        if showLoader { LoaderView.show() }
        
        let request = SDWebImageManager.shared.loadImage(with: url, progress: { (receivedSize, expectedSize, _) in
            LoaderView.update(progress: Float(receivedSize / expectedSize))
        }) { (image, data, error, _, _, _) in
            if showLoader { LoaderView.hide() }
            if let image = image {
                onComplete(image, nil)
            }else {
                onComplete(nil, error)
            }
        }
        
        if showLoader { LoaderView.shared.imageOperation = request }
    }
}
