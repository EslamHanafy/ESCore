//
//  ImageUploader.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/8/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
/*
public class ImageUploader {
    private var fileURL: URL?
    private var uploadingURL: URL?
    
    public init () {}
    
    public func upload(_ image: UIImage, forAction action: String) -> Single<URL> {
        return getUploadingUrl(forAction: action).andThen(upload(image))
    }
}

//MARK: - Helpers
private extension ImageUploader {
    private func getUploadingUrl(forAction action: String = "profileAvatar") -> Completable {
        let request = Alamofire.request(APIConstants.getUploadURL, method: .post, parameters: ["uploadAction": action, "contentType": "image/png"], encoding: JSONEncoding.default, headers: BaseAPI.headers)
        LoaderView.shared.request = request
        return Completable.create { (completable) -> Disposable in
            let disposable = request.rx.responseJSONObject(usingMainLoader: true).subscribe(onSuccess: { [weak self] (json) in
                if json["statusCode"].intValue == 200 {
                    if let upload = URL(string: json["uploadURL"].stringValue), let file = URL(string: json["fileUrl"].stringValue) {
                        self?.fileURL = file
                        self?.uploadingURL = upload
                        completable(.completed)
                    } else {
                        completable(.error(ESError.unknown))
                    }
                } else {
                    completable(.error(ESError.unknown))
                }
                
            }) { (error) in
                completable(.error(error))
            }
            
            return Disposables.create {
                request.cancel()
                disposable.dispose()
            }
        }
    }
    
    private func upload(_ image: UIImage) -> Single<URL> {
        return Single<URL>.create { [weak self] (single) -> Disposable in
            var request: UploadRequest?
            if let data = image.pngData(), let uploadURL = self?.uploadingURL, let fileURL = self?.fileURL {
                request = Alamofire.upload(data, to: uploadURL, method: .put, headers: ["Content-Type":"image/png"])
                request!.validate()
                LoaderView.shared.request = request
                request!.uploadProgress(queue: DispatchQueue.main) { (progress: Progress) in
                    LoaderView.update(progress: Float(progress.fractionCompleted))
                }
                request!.responseString { (response) in
                    Log.debug(response.debugDescription)
                    //check if there is status code if it was nil, it's mean that the request has been cancelled
                    guard let code = response.response?.statusCode else { return }
                    
                    if let error = NetworkError(with: code) {
                        single(.error(error))
                    } else {
                        single(.success(fileURL))
                    }
                }
            } else {
                single(.error(ESError.message("imageNotValid".selfLocalized)))
            }
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
}
*/
