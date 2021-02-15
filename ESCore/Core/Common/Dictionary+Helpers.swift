//
//  Dictionary+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 15/02/2021.
//  Copyright © 2021 Eslam. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// Returns the element at the specified key if it is found, otherwise nil.
    subscript(safe key: Key) -> Value? {
        return has(key: key) ? self[key] : nil
    }
}
