//
//  UIImage+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

public extension UIImage {
    var base64String: String {
        let imageData = self.jpegData(compressionQuality: 0.5)
        return  (imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)) ?? ""
    }
}

// MARK: - Methods
public extension UIImage {
    @discardableResult
    func store(withName name: String, at folder: String) -> URL? {
        if let data = jpegData(compressionQuality: 0.7) {
            return FileManager.store(fileData: data, withName: name + ".jpg", atFolder: folder)
        }
        
        return nil
    }
    
    func show(from: UIImageView? = nil) {
        ESImageViewer.shared.show(self)
    }
}

// MARK: - Initializers
public extension UIImage {
    convenience init?(coreNamed: String) {
        self.init(named: coreNamed, in: currentBundle, compatibleWith: nil)
    }
}

public extension Sequence where Iterator.Element == UIImage? {
    /// Preview the images using the `ESImageViewer` class
    /// - Parameters:
    ///   - index: the start index
    func showImages(startingAt index: Int = 0) {
        ESImageViewer.shared.show(Array(self), startingAt: index)
    }
}

public extension Sequence where Iterator.Element == UIImage {
    /// Preview the images using the `ESImageViewer` class
    /// - Parameter index: the start index
    func showImages(startingAt index: Int = 0) {
        ESImageViewer.shared.show(Array(self), startingAt: index)
    }
}
