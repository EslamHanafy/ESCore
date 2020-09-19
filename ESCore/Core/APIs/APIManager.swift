//
//  APIManager.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/19/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import Alamofire

extension ESCore {
    open class APIManager {
        open var headers: HTTPHeaders? = [.acceptLanguage(language)]
        open var acceptedStatusCodes: [Int] = [200, 204, 201]
        open var settings: Settings = Settings()
        open var onSessionExpired: (()->())?
        open var expirationStatusCodes: [Int] = [401, 403]
        
        
        open func request<Parameters: Encodable>(_ convertible: URLConvertible,
                                            method: HTTPMethod = .get,
                                            parameters: Parameters? = nil,
                                            encoder: ParameterEncoder = JSONParameterEncoder.default,
                                            headers: HTTPHeaders? = nil,
                                            interceptor: RequestInterceptor? = nil,
                                            requestModifier: ((inout URLRequest) throws -> Void)? = nil
        ) -> DataRequest {
            return AF.request(convertible, method: method, parameters: parameters, encoder: encoder, headers: headers ?? self.headers, interceptor: interceptor, requestModifier: requestModifier)
        }
        
        
        
        public struct Settings {
            public var statusKey: String = "statusCode"
            public var messageKey: String = "message"
            public var loadingMessage: String = "loading".selfLocalized
            
            public init() {}
        }
    }
}
