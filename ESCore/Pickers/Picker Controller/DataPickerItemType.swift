//
//  DataPickerItemType.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

public protocol DataPickerItemType {
    var title: String { get }
    var image: UIImage? { get }
}

public extension DataPickerItemType {
    var image: UIImage? {
        return nil
    }
}
