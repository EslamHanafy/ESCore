//
//  Mapable.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/6/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol Mapable {
    associatedtype T
    
    /// Map the given `JSON` to an object of the class
    /// - Parameter json: `JSON` object that contains the data
    /// - Returns: An object of the class
    static func map(_ json: JSON) -> T
}
