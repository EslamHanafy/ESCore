//
//  ESDataPickerItemType.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

public protocol ESDataPickerItemType {
    var title: String { get }
    var image: UIImage? { get }
}

public extension ESDataPickerItemType {
    var image: UIImage? {
        return nil
    }
}
