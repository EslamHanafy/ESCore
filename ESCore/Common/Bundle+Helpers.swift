//
//  Bundle+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/16/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation

private class testBundle: NSObject {}

internal let currentBundle: Bundle = bundle(for: testBundle())

public extension Bundle {
    static var core: Bundle {
        return currentBundle
    }
    
    static var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    static var appBuild: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
}
