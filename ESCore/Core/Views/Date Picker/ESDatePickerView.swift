//
//  ESDatePickerView.swift
//  ESCore
//
//  Created by Eslam Hanafy on 2/6/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit
import SwiftDate
import RxCocoa
import RxSwift

open class ESDatePickerView: ESPopupView {
    @IBOutlet open var picker: UIDatePicker!
    @IBOutlet open var label: ESLabel!
    @IBOutlet open var cancelButton: ESButton!
    @IBOutlet open var nowButton: ESButton!
    @IBOutlet open var selectButton: ESButton!
    
    open var mode: UIDatePicker.Mode = .dateAndTime {
        didSet {
            self.picker.datePickerMode = mode
        }
    }
    
    open var date: Date {
        get { return picker.date }
        set { picker.date = newValue; label.text = newValue.currentRegion.toFormat(format) }
    }
    
    open var format: String {
        get { return _format.value }
        set { _format.accept(newValue) }
    }
    
    open var onSelectDate: ((_ date: Date)-> Void)?
    
    private var _format = BehaviorRelay<String>(value: "yyyy-MM-dd HH:mm:ss")
    
    private let bag = DisposeBag()
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        Observable.combineLatest(picker.rx.date.asObservable(), _format.asObservable())
            .map({ $0.0.currentRegion.toFormat($0.1) })
            .bind(to: label.rx.text).disposed(by: bag)
        
        fixStyle()
    }
    
    
    
    public static func getInstance(for controller: UIViewController? = currentController) -> ESDatePickerView {
        let view = currentBundle.loadNibNamed("DatePickerView", owner: controller, options: nil)?.last as! ESDatePickerView
        view.initFor(controller: controller ?? UIViewController())
        return view
    }
    
    
    public func selectedDate(_ handler: @escaping (_ date: Date)-> Void) {
        self.onSelectDate = handler
    }
    
    
    //MARK: - IBActions
    @IBAction func selectAction() {
        hideAnimation { [weak self] in
            guard let self = self else { return }
            self.onSelectDate?(self.picker.date)
        }
    }
    
    @IBAction func cancelAction() {
        hideAnimation()
    }
    
    @IBAction func nowAction() {
        picker.date = Date()
    }
}

//MARK: - Helpers
private extension ESDatePickerView {
    func fixStyle() {
        label.font = Fonts.main
        cancelButton.titleLabel?.font = Fonts.bold
        nowButton.titleLabel?.font = Fonts.bold
        selectButton.titleLabel?.font = Fonts.bold
    }
}
