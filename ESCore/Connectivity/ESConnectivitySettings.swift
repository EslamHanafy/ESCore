//
//  ESConnectivitySettings.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/14/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

public struct ESConnectivitySettings {
    public var backgroundColor: UIColor = .black
    
    public var titleTextColor: UIColor = .white
    public var titleText: String = "DisconnectedView_Title".selfLocalized
    public var titleFont: UIFont = Fonts.bold
    
    public var hideRetryButton: Bool = false
    public var retryButtonTextColor: UIColor = .red
    public var retryButtonBackgroundColor: UIColor = .white
    public var retryButtonCornerRadius: CGFloat = 8.0
    public var retryButtonNormalText: String = "DisconnectedView_Retry".selfLocalized
    public var retryButtonDisabledText: String = "DisconnectedView_CheckingConnection".selfLocalized
    public var retryButtonFont: UIFont = .boldSystemFont(ofSize: 20)
    
    public var alertType: ESConnectivityManager.AlertType = .message
    
    public var connectedAlert: String = "internetConnected".selfLocalized
    public var disconnectedAlert: String = "noInternet".selfLocalized
    
    public var disconnectedImage: UIImage? = nil
    
    
    public init () {}
}
