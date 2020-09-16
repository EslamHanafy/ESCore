//
//  ESLoaderType.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/16/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage

public protocol ESLoaderType: AnyObject {
    var request: Request? { get set }
    var imageOperation: SDWebImageCombinedOperation? { get set }
    
    
    func show()
    func show(withTitle title: String?)
    func show(with request: Request?, andTitle title: String?)
    func hide()
    func comeToWindowIfNeeded()
    func update(progress: Float)
    func cancelRequests()
}
