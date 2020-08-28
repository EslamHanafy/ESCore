//
//  ReasonCollectionViews.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/29/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

open class ReasonCollectionViews: UICollectionView {
    @IBOutlet var collectionHeightConstraint: NSLayoutConstraint!
    
    
    open var items: [String] = [] {
        didSet {
            self.reloadData()
        }
    }

    open var selectedItems: [String] {
        return self.indexPathsForSelectedItems.unwrapped(or: []).map({ items[$0.item] })
    }
    
    open var layout: AlignedCollectionViewFlowLayout  = AlignedCollectionViewFlowLayout(horizontalAlignment: .leading, verticalAlignment: .top)
    
    open var onSelectItem: ((_ item: String)-> Void)?
    open var onDesSelectItem: ((_ item: String)-> Void)?
    
    
    open override var contentSize: CGSize {
        didSet {
            self.collectionHeightConstraint.constant = contentSize.height
        }
    }
    
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
        
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
    }
    
}

//MARK: - Helpers
public extension ReasonCollectionViews {
    func clearSelections() {
        self.indexPathsForSelectedItems.unwrapped(or: []).forEach({ [weak self] in
            guard let self = self else { return }
            self.deselectItem(at: $0, animated: false)
        })
    }
}

//MARK: - Delegate And Data Sources
extension ReasonCollectionViews: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ReasonCollectionViewCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = currentBundle.loadNibNamed("ReasonCollectionViewCell", owner: self, options: nil)?.last as! ReasonCollectionViewCell
        cell.configure(with: items[indexPath.item])
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: max(size.width, screenWidth * 0.8), height: size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.item])
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        onDesSelectItem?(items[indexPath.item])
    }
    
    func commonInit() {
        self.register(UINib(nibName: "ReasonCollectionViewCell", bundle: currentBundle), forCellWithReuseIdentifier: "Cell")
        self.allowsMultipleSelection = true
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        
        initCollectionLayout()
    }
    
    func initCollectionLayout() {
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 30
        layout.sectionInset = .zero
        self.setCollectionViewLayout(layout, animated: false)
    }
}
