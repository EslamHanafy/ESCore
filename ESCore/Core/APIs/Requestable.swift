//
//  Requestable.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/26/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Alamofire

public protocol Requestable {
    var parameters: Parameters { get }
}
