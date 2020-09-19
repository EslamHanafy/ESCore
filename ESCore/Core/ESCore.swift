//
//  ESCore.swift
//  ESCore
//
//  Created by Eslam Hanafy on 8/28/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import Alamofire

public let userDefaults_accesstokenKey: String = "ES_Accesstoken_Key"
public typealias ESAPIManager = ESCore.APIManager

public final class ESCore {
    public static var loaderView: ESLoaderType = ESLoaderView.shared
    
    public static var accesstoken: String {
        get { return UserDefaults.standard.string(forKey: userDefaults_accesstokenKey).safeValue }
        set { UserDefaults.standard.setValue(newValue, forKey: userDefaults_accesstokenKey) }
    }
     
    public static var apiManager: APIManager = APIManager()
}
