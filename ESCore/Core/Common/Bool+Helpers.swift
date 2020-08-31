//
//  Bool+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/1/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

public extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }

    var stringValue: String {
        return self ? "true" : "false"
    }

}
