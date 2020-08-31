//
//  Objc_AssociatedObject+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 10/29/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import ObjectiveC

public func objc_getSafeObject<T>(_ object: Any, _ key: UnsafeRawPointer!, defaultValue: T) -> T {
    guard let value = objc_getAssociatedObject(object, key) as? T else {
        return defaultValue
    }
    return value
}

public func objc_setValue<T>(_ object: Any, _ key: UnsafeRawPointer!, newValue: T) {
    objc_setAssociatedObject(object, key, newValue, .OBJC_ASSOCIATION_RETAIN)
}
