//
//  DataPickerTableViewCell.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

class DataPickerTableViewCell: UITableViewCell {
    var imageSize: CGSize = .zero
    var item: DataPickerItemType!

    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame.size = imageSize
        imageView?.center.y = contentView.center.y
    }
    
    
    func configure(with item: DataPickerItemType, and style: DataPickerStyle, isSelected: Bool) {
        self.textLabel?.text = item.title
        
        self.imageView?.image = item.image
        self.imageSize = style.itemImageSize
        self.imageView?.clipsToBounds = true
        
        self.imageView?.layer.cornerRadius = style.itemImageCornerRadius
        self.imageView?.layer.masksToBounds = true
        
        self.textLabel?.font = style.itemFont
        self.textLabel?.textColor = style.itemTextColor
        
        self.accessoryType = isSelected &&
            style.showCheckMark ? .checkmark : .none
        self.separatorInset = .zero
    }
}
