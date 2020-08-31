//
//  URL+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import AVKit
import MobileCoreServices

public extension URL {
    var mimeType: String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, self.pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    var image: UIImage? {
        if let data = try? Data(contentsOf: self) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func showImage(from view: UIImageView? = nil) {
        ImageViewer.show(self)
    }
    
    @discardableResult
    func open() -> Bool {
        if UIApplication.shared.canOpenURL(self) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(self, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(self)
            }
            return true
        }
        return false
    }
    
    func playVideo() {
        let controller = AVPlayerViewController()
        if #available(iOS 11.0, *) {
            controller.entersFullScreenWhenPlaybackBegins = true
            controller.exitsFullScreenWhenPlaybackEnds = true
        }
        
        let player = AVPlayer(url: self)
        controller.player = player
        
        currentController?.present(controller, animated: true) {
            player.play()
        }
    }
    
    
    func getQueryStringParameter(_ param: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }

}

public extension Sequence where Iterator.Element == URL? {
    func showImages(from view: UIImageView?, startingAt index: Int = 0) {
        ImageViewer.show(Array(self), startingAt: index)
    }
}

public extension Sequence where Iterator.Element == URL {
    func showImages(from view: UIImageView?, startingAt index: Int = 0) {
        ImageViewer.show(Array(self), startingAt: index)
    }
}
