//
//  UIApplication+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 7/27/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

public extension UIApplication {
    var isInForeground: Bool {
        return applicationState == .active
    }
}
