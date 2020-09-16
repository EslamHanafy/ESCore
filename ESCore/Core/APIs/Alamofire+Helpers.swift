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
                        return single(.error(ESError.unknown))
                    }
                }
                
                if let error = NetworkError(with: code) {
                    return single(.error(error))
                }
                
                if let data = response.value {
                    return single(.success(JSON(data)))
                } else {
                    Log.debug("The cancel goes here eslam")
                    return single(.error(ESError.unknown))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func responseValidJson(with loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false) -> Single<JSON> {
        loaderView?.startAnimating()
        if usingMainLoader { ESCore.loaderView.show(with: self.base, andTitle: "loading".selfLocalized) }
        
        return Single<JSON>.create { (single) -> Disposable in
            let disposable = self.responseJSONObject(with: loaderView, usingMainLoader: usingMainLoader).subscribe(onSuccess: { (json) in
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
                if json["statusCode"].intValue == 200 || json["statusCode"].intValue == 204 || json["statusCode"].intValue == 201 {
                    single(.success(json))
                } else {
                    single(.error(ESError.message(json["message"].stringValue)))
                }
            }) { (error) in
                if usingMainLoader { ESCore.loaderView.hide() }
                loaderView?.stopAnimating()
                single(.error(error))
            }
            
            return Disposables.create {
                loaderView?.stopAnimating()
                disposable.dispose()
                self.base.cancel()
                if usingMainLoader { ESCore.loaderView.hide() }
            }
        }
    }
    
    func responseItems<T: Mapable>(withKey key: String, and loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false) -> Single<[T]> {
        loaderView?.startAnimating()
        if usingMainLoader { ESCore.loaderView.show(with: self.base, andTitle: "loading".selfLocalized) }
        return Single<[T]>.create { (single) -> Disposable in
            let disposable = self.responseJSONObject(with: loaderView, usingMainLoader: usingMainLoader).subscribe(onSuccess: { (json) in
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
                if json["statusCode"].intValue == 200 || json["statusCode"].intValue == 204 {
                    let items = json[key].arrayValue.map(T.map) as! [T]
                    single(.success(items))
                } else {
                    single(.error(ESError.message(json["message"].stringValue)))
                }
            }) { (error) in
                if usingMainLoader { ESCore.loaderView.hide() }
                loaderView?.stopAnimating()
                single(.error(error))
            }
            return Disposables.create {
                loaderView?.stopAnimating()
                disposable.dispose()
                self.base.cancel()
                if usingMainLoader { ESCore.loaderView.hide() }
            }
        }
    }
    
    func responseItem<T: Mapable>(withKey key: String, and loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false) -> Single<T> {
        loaderView?.startAnimating()
        if usingMainLoader { ESCore.loaderView.show(with: self.base, andTitle: "loading".selfLocalized) }
        return Single<T>.create { (single) -> Disposable in
            let disposable = self.responseJSONObject(with: loaderView, usingMainLoader: usingMainLoader).subscribe(onSuccess: { (json) in
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
                if json["statusCode"].intValue == 200 || json["statusCode"].intValue == 204 {
                    let item = T.map(json[key]) as! T
                    single(.success(item))
                } else {
                    single(.error(ESError.message(json["message"].stringValue)))
                }
            }) { (error) in
                if usingMainLoader { ESCore.loaderView.hide() }
                loaderView?.stopAnimating()
                single(.error(error))
            }
            return Disposables.create {
                loaderView?.stopAnimating()
                disposable.dispose()
                self.base.cancel()
                if usingMainLoader { ESCore.loaderView.hide() }
            }
        }
    }
    
    func responseCompletable(with loaderView: NVActivityIndicatorView? = nil, usingMainLoader: Bool = false) -> Completable {
        loaderView?.startAnimating()
        if usingMainLoader { ESCore.loaderView.show(with: self.base, andTitle: "loading".selfLocalized) }
        return Completable.create { (completable) -> Disposable in
            let disposable = self.responseJSONObject(with: loaderView, usingMainLoader: usingMainLoader).subscribe(onSuccess: { (json) in
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
                if json["statusCode"].intValue == 200 {
                    completable(.completed)
                } else {
                    completable(.error(ESError.message(json["message"].stringValue)))
                }
            }) { (error) in
                if usingMainLoader { ESCore.loaderView.hide() }
                loaderView?.stopAnimating()
                completable(.error(error))
            }
            
            return Disposables.create {
                disposable.dispose()
                loaderView?.stopAnimating()
                if usingMainLoader { ESCore.loaderView.hide() }
            }
        }
    }
}

extension DataRequest: ReactiveCompatible {}
