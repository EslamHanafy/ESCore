//
//  ChipCollectionViewCell.swift
//  EslamCore
//
//  Created by Eslam on 3/24/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import IBAnimatable


class ChipCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerView: CustomView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var itemHeightConstraint: NSLayoutConstraint!
    
    
    var style: ChipView.Style!
    var item: ChipItemType!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        itemHeightConstraint.constant = ChipView.itemHeight
    }

    
    func configure(for item: ChipItemType, with style: ChipView.Style) {
        self.style = style
        self.item = item
        self.titleLabel.text = item.title
        self.isUserInteractionEnabled = item.status != .disabled
        self.updateStyle()
        self.updateItemHeight()
    }
    
    
    func updateStyle() {
        guard style != nil else {
            return
        }
        
        switch item.status {
        case .none:
            containerView.backgroundColor = style.normalColor
            containerView.borderColor = style.normalBorderColor
            titleLabel.textColor = style.normalFontColor
            titleLabel.font = style.normalFont
            
        case .disabled:
            containerView.backgroundColor = style.disabledColor
            containerView.borderColor = style.disabledBorderColor
            titleLabel.textColor = style.disabledFontColot
            titleLabel.font = style.disableFont
            
        case .selected:
            containerView.backgroundColor = style.selectedColor
            containerView.borderColor = style.selectedBorderColor
            titleLabel.textColor = style.selectedFontColor
            titleLabel.font = style.selectedFont
        }
    }
    
    func updateItemHeight() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: style.maxItemWidth, height: 10))
        label.font = self.titleLabel.font
        label.text = self.titleLabel.text
        let lines = label.maxNumberOfLines
        self.titleLabel.numberOfLines = lines
        self.itemHeightConstraint.constant = ChipView.itemHeight * lines.cgFloatValue
    }
}
