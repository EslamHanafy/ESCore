//
//  ESError.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/22/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation

public enum ESError: Error, LocalizedError {
    case message(_ msg: String)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case let .message(msg):
            return msg
        case .unknown:
            return "unknownError".localized
        }
    }
    
    public init(_ message: String) {
        self = .message(message)
    }
}
