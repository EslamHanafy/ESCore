//
//  Sequence+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 8/28/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

//MARK: - Optional
public extension Sequence where Iterator.Element: OptionalType {
    func unwrap() -> [Iterator.Element.Wrapped] {
        return self.compactMap({ $0.optional })
    }
}
