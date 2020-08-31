//
//  String+RXHelpers.swift
//  EslamCore
//
//  Created by Eslam on 1/16/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import RxSwift

extension String {
    enum AlertError: Error {
        case cannotDetermineCurrentController
    }
    
    func rxDisplay(withTitle title: String? = nil, fromController controller: UIViewController? = nil)-> Completable {
        return Completable.create { completable in
            let alert = UIAlertController(title: title?.localized, message: self.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok".selfLocalized, style: .default, handler: { (_) in
                completable(.completed)
            }))
            
            let disposable = Disposables.create {
                mainQueue {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
            guard let controller = controller ?? currentController else {
                completable(.error(AlertError.cannotDetermineCurrentController))
                return disposable
            }
            
            mainQueue {
                controller.present(alert, animated: true, completion: nil)
            }
            
            return disposable
        }
    }
}
