//
//  ESViewController.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/15/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit
import RxSwift

open class ESViewController: UIViewController {
    /// Determine if the controller loaded it's subviews or not, it sets to `true` in `viewDidLoad` method.
    open var didLoadViews: Bool = false
    
    /// Determine if the screen appear for the first time or not, it sets to `true` in `viewDidAppear` method.,
    open var isFirstTime: Bool = false
    
    open lazy var bag = DisposeBag()
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        didLoadViews = true
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isFirstTime = true
    }
    
    
    @IBAction open func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
