//
//  SnackBar.swift
//  EslamCore
//
//  Created by Eslam on 12/23/18.
//  Copyright © 2018 Eslam. All rights reserved.
//

import Foundation
import TTGSnackbar

open class SnackBar {
    public static let shared: SnackBar = SnackBar()
    
    
    fileprivate lazy var snackbar: TTGSnackbar = {
        return getSnackBar()
    }()
    
    
    
    public func show(message: String, withColor color: UIColor = .black) {
        snackbar.duration = .middle
        snackbar.message = message
        snackbar.backgroundColor = color
        snackbar.show()
    }
    
    
    private func getSnackBar() -> TTGSnackbar {
        let snackbar = TTGSnackbar(message: "", duration: .long)
        snackbar.leftMargin = 0
        snackbar.messageTextFont =  Fonts.main
        snackbar.rightMargin = 0
        snackbar.animationType = .slideFromTopBackToTop
        snackbar.messageTextAlign = .center
        snackbar.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 8, right: 0)
        snackbar.messageTextColor = .white
        snackbar.backgroundColor = .red
        return snackbar
    }
}
