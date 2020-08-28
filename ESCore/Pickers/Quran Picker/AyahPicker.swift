//
//  AyahPicker.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/31/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

open class AyahPicker {
    private var picker: DataPickerViewController!
    
    public var onSelectAyah: ((_ ayah: Int) -> Void)?
    
    public var surah: Surah
    
    
    
    public init(_ surah: Surah, style: DataPickerStyle) {
        self.surah = surah
        
        style.showSectionIndexTitles = false
        
        let data = DPDataSource(screenTitle: surah.localizedName, items: [surah.localizedName: surah.ayahArray])
        self.picker = DataPickerViewController(with: data, and: style)
        
        self.picker.selectedItem(type: Int.self) { [weak self] (item) in
            self?.onSelectAyah?(item)
        }
    }
    
    
    
    
    public func show(from controller: UIViewController? = currentController, _ onSelectHandler: ((_ ayah: Int) -> Void)? = nil) {
        picker.show(from: controller)
        if let handler = onSelectHandler {
            self.onSelectAyah = handler
        }
    }
}

extension Int: DataPickerItemType {
    public var title: String {
        return self.stringValue
    }
}
