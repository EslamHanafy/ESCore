//
//  UITextField+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/22/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

public extension UITextField {
    var isEmpty: Bool {
        return text?.withoutSpaces.isEmpty != false
    }
}
