//
//  NetworkError.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/22/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkError: String, Error, LocalizedError {
    case unknownError
    case noConnection
    case serverError
    case unauthorized
    case forbidden
    case notFound
    
    
    public var errorDescription: String? {
        switch self {
        case .noConnection:
            return "noInternet".selfLocalized
        case .serverError:
            return "unknownError".selfLocalized
        case .unauthorized:
            return "forbidden".selfLocalized
        case .forbidden:
            return "forbidden".selfLocalized
        case .notFound:
            return "itemsNotFound".selfLocalized
        default:
            return "unknownError".selfLocalized
        }
    }
    
    public init?(with code: Int) {
        if ESCore.apiManager.expirationStatusCodes.contains(code) {
            ESCore.apiManager.onSessionExpired?()
        }
        
        switch code {
        case 200...300:
            return nil
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 405...499:
            return nil
        default:
            self = isConnectedToNetwork ? .unknownError : .noConnection
        }
    }
}
