//
//  ESAyahPicker.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/31/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

open class ESAyahPicker {
    private var picker: ESDataPickerViewController!
    
    public var onSelectAyah: ((_ ayah: Int) -> Void)?
    
    public var surah: ESSurah
    
    
    
    public init(_ surah: ESSurah, style: ESDataPickerStyle) {
        self.surah = surah
        
        style.showSectionIndexTitles = false
        
        let data = DPDataSource(screenTitle: surah.localizedName, items: [surah.localizedName: surah.ayahArray])
        self.picker = ESDataPickerViewController(with: data, and: style)
        
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

extension Int: ESDataPickerItemType {
    public var title: String {
        return self.stringValue
    }
}
