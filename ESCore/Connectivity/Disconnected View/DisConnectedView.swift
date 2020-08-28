//
//  DisConnectedView.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import SwiftyGif

open class DisConnectedView: UIView {
    @IBOutlet var imageView: UIImageView!
    
    public static func getInstance(for owner: AnyObject) -> DisConnectedView {
        return (bundle(for: owner).loadNibNamed("DisConnectedView", owner: owner, options: nil)?.last as! DisConnectedView)
    }

    
    open override func awakeFromNib() {
        super.awakeFromNib()
        let data = try! Data(contentsOf: URL(fileURLWithPath: bundle(for: self).path(forResource: "cryImage.gif", ofType: nil)!))
        imageView.setGifImage(try! UIImage(gifData: data), loopCount: -1)
        imageView.startAnimating()
    }
}
