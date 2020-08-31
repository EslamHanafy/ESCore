//
//  UITableViewCell+Helpers.swift
//  EslamCore
//
//  Created by Eslam Hanafy on 1/30/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    var parentTableView: UITableView? {
        return parentView(of: UITableView.self)
    }
}
