//
//  UserGuide.swift
//  ESCore
//
//  Created by Eslam Hanafy on 8/18/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

open class UserGuide {
    private var items: [MaterialShowcase] = []
    private var sequence: MaterialShowcaseSequence?
    
    open var onDismissed: (()->())?
    
    
    public init() {}
    
    
    @discardableResult
    open func show(_ items: [Item]) -> Self {
        guard !items.isEmpty else {
            return self
        }
        
        self.items = items.compactMap({ $0.showcase })
        
        sequence = MaterialShowcaseSequence()
        sequence?.showcaseArray = self.items
        self.items.forEach({ $0.delegate = self })
        sequence?.start()
        
        return self
    }
    
    @discardableResult
    open func show(_ item: Item) -> Self {
        self.items = [item.showcase]
        item.showcase.delegate = self
        item.show()
        return self
    }
    
    
    @discardableResult
    open func then(_ clouser: @escaping ()->()) -> Self {
        onDismissed = clouser
        return self
    }
}

// MARK: - MaterialShowcaseDelegate
extension UserGuide: MaterialShowcaseDelegate {
    public func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence?.showCaseWillDismis()
        self.items.removeAll(showcase)
        if self.items.isEmpty {
            self.onDismissed?()
        }
    }
}

//MARK: - Guide Item
public extension UserGuide {
    class Item: Equatable {
        public let showcase = MaterialShowcase()
        
        public let target: UIView
        public let primaryText: String
        public let secondaryText: String
        
        open var primaryFont: UIFont = Fonts.bold {
            didSet {
                showcase.primaryTextFont = primaryFont
            }
        }
        
        open var secondaryFont: UIFont = Fonts.main {
            didSet {
                showcase.secondaryTextFont = secondaryFont
            }
        }
        
        open var backgroundColor: UIColor = UIApplication.shared.keyWindow?.tintColor ?? .white {
            didSet {
                showcase.backgroundPromptColor = backgroundColor
            }
        }
        
        
        public init(_ target: UIView, primaryText: String, secondaryText: String) {
            self.target = target
            self.primaryText = primaryText
            self.secondaryText = secondaryText
            
            commoinInit()
        }
        
        
        @discardableResult
        open func show() -> Self {
            showcase.show(completion: nil)
            return self
        }
        
        private func commoinInit() {
            showcase.setTargetView(view: target)
            showcase.primaryText = primaryText
            showcase.secondaryText = secondaryText
            showcase.primaryTextFont = primaryFont
            showcase.secondaryTextFont = secondaryFont
            showcase.primaryTextAlignment = isRTL ? .right : .left
            showcase.secondaryTextAlignment = isRTL ? .right : .left
            showcase.backgroundPromptColor = backgroundColor
        }
        
        public static func == (lhs: UserGuide.Item, rhs: UserGuide.Item) -> Bool {
            return lhs.showcase == rhs.showcase
        }
    }
}
