//
//  ReasonCollectionViewCell.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/29/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit
import IBAnimatable

open class ReasonCollectionViewCell: UICollectionViewCell {
    @IBOutlet open var titleLabel: UILabel!
    @IBOutlet open var statusImageView: AnimatableImageView!
    @IBOutlet open var itemHeightConstraint: NSLayoutConstraint!
    
    let itemHeight: CGFloat = 30
    let maxWidth: CGFloat = screenWidth * 0.8
    
    override open var isSelected: Bool {
        didSet {
            self.statusImageView.image = isSelected ? UIImage(coreNamed: "agree") : nil
        }
    }
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        itemHeightConstraint.constant = itemHeight
        titleLabel.font = Fonts.main
    }

    
    open func configure(with title: String) {
        titleLabel.text = title
        updateItemHeight()
    }
    
    private func updateItemHeight() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: 10))
        label.font = self.titleLabel.font
        label.text = self.titleLabel.text
        let lines = label.maxNumberOfLines
        self.titleLabel.numberOfLines = lines
        self.itemHeightConstraint.constant = itemHeight * lines.cgFloatValue
        self.layoutIfNeeded()
    }
}
