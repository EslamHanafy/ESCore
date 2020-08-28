//
//  ESRealm+RxSwift.swift
//  EslamCore
//
//  Created by Eslam Hanafy on 1/15/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

#if canImport(RealmSwift)
import Foundation
import RealmSwift
import RxSwift

public extension ObservableType where Element: Object {
    func cacheObject(update: Bool = true) -> Observable<Element> {
        return self.do(onNext: { (object) in
            ESRealm.add(object, update: update)
        })
    }
}

public extension ObservableType where Element: Sequence, Element.Element: Object {
    func cacheObjects(update: Bool = true) -> Observable<Element> {
        return self.do(onNext: { (objects) in
            ESRealm.add(objects, update: update)
        })
    }
}

#endif
