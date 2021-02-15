//
//  Alamofire+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/22/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import NVActivityIndicatorView


//MARK: - Rx Helpers
public extension Reactive where Base: DataRequest {
    func responseJSONObject(with loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false) -> Single<JSON> {
        return Single<JSON>.create { (single) -> Disposable in
            let request = self.base.responseJSON { (response) in
                Log.debug(response.debugDescription)
                Log.debug(response.request?.allHTTPHeaderFields ?? [:])
                //check if there is status code if it was nil, it's mean that the request has been cancelled
                guard let code = response.response?.statusCode else {
                    if usingMainLoader { ESCore.loaderView.hide() }
                    loaderView?.stopAnimating()
                    
                    if response.error?._code == NSURLErrorCancelled {
                        return
                    } else {
                        return single(.failure(ESError.unknown))
                    }
                }
                
                if let error = NetworkError(with: code) {
                    return single(.failure(error))
                }
                
                if let data = response.value {
                    return single(.success(JSON(data)))
                } else {
                    Log.debug("The cancel goes here eslam")
                    return single(.failure(ESError.unknown))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func responseValidJson(with loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false, acceptedStatusCode: [Int]? = nil) -> Single<JSON> {
        loaderView?.startAnimating()
        if usingMainLoader { ESCore.loaderView.show(with: self.base, andTitle: ESCore.apiManager.settings.loadingMessage) }
        
        return Single<JSON>.create { (single) -> Disposable in
            let disposable = self.responseJSONObject(with: loaderView, usingMainLoader: usingMainLoader).subscribe(onSuccess: { (json) in
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
                if (acceptedStatusCode ?? ESCore.apiManager.acceptedStatusCodes).contains(json[ESCore.apiManager.settings.statusKey].intValue) {
                    single(.success(json))
                } else {
                    single(.failure(ESError.message(json[ESCore.apiManager.settings.messageKey].stringValue)))
                }
            }, onFailure: { (error) in
                if usingMainLoader { ESCore.loaderView.hide() }
                loaderView?.stopAnimating()
                single(.failure(error))
            })
            
            return Disposables.create {
                loaderView?.stopAnimating()
                disposable.dispose()
                self.base.cancel()
                if usingMainLoader { ESCore.loaderView.hide() }
            }
        }
    }
    
    func responseItems<T: Mapable>(withKey key: String, and loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false, acceptedStatusCode: [Int]? = nil) -> Single<[T]> {
        return responseValidJson(with: loaderView, usingMainLoader: usingMainLoader, acceptedStatusCode: acceptedStatusCode).map { (json) in
            let items = json[key].arrayValue.map(T.map) as! [T]
            return items
        }
    }
    
    func responseItem<T: Mapable>(withKey key: String, and loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false, acceptedStatusCode: [Int]? = nil) -> Single<T> {
        
        return responseValidJson(with: loaderView, usingMainLoader: usingMainLoader, acceptedStatusCode: acceptedStatusCode).map { (json) in
            let item = T.map(json[key]) as! T
            return item
        }
    }
    
    func responseCompletable(with loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false, acceptedStatusCode: [Int]? = nil) -> Completable {
        loaderView?.startAnimating()
        if usingMainLoader { ESCore.loaderView.show(with: self.base, andTitle: ESCore.apiManager.settings.loadingMessage) }
        return Completable.create { (completable) -> Disposable in
            let disposable = self.responseJSONObject(with: loaderView, usingMainLoader: usingMainLoader).subscribe(onSuccess: { (json) in
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
                if (acceptedStatusCode ?? ESCore.apiManager.acceptedStatusCodes).contains(json[ESCore.apiManager.settings.statusKey].intValue) {
                    completable(.completed)
                } else {
                    completable(.error(ESError.message(json[ESCore.apiManager.settings.messageKey].stringValue)))
                }
            }, onFailure: { (error) in
                if usingMainLoader { ESCore.loaderView.hide() }
                loaderView?.stopAnimating()
                completable(.error(error))
            })
            
            return Disposables.create {
                disposable.dispose()
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
            }
        }
    }
}

extension DataRequest: ReactiveCompatible {}
