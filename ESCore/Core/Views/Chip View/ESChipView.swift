//
//  ESChipView.swift
//  EslamCore
//
//  Created by Eslam on 3/24/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

open class ESChipView: UICollectionView {
    @IBOutlet public var chipHeightConstraint: NSLayoutConstraint!
    
    @IBInspectable open var normalFont: String = "main" {
        didSet {
            style.normalFont = Fonts.font(for: normalFont)
            self.reloadData()
        }
    }
    
    
    @IBInspectable open var normalColor: UIColor = .clear {
        didSet {
            style.normalColor = normalColor
            self.reloadData()
        }
    }
    
    @IBInspectable open var normalFontColor: UIColor = .black {
        didSet {
            style.normalFontColor = normalFontColor
            self.reloadData()
        }
    }
    
    @IBInspectable open var normalBorderColor: UIColor = .black {
        didSet {
            style.normalBorderColor = normalBorderColor
            self.reloadData()
        }
    }
    
    
    @IBInspectable open var selectedFont: String = "main" {
        didSet {
            style.selectedFont = Fonts.font(for: selectedFont)
            self.reloadData()
        }
    }
    
    @IBInspectable open var selectedColor: UIColor = .blue {
        didSet {
            style.selectedColor = selectedColor
            self.reloadData()
        }
    }
    
    @IBInspectable open var selectedFontColor: UIColor = .white {
        didSet {
            style.selectedFontColor = selectedFontColor
            self.reloadData()
        }
    }
    
    @IBInspectable open var selectedBorderColor: UIColor = .white {
        didSet {
            style.selectedBorderColor = selectedBorderColor
            self.reloadData()
        }
    }
    
    @IBInspectable open var disabledFont: String = "main" {
        didSet {
            style.disableFont = Fonts.font(for: disabledFont)
            self.reloadData()
        }
    }
    
    @IBInspectable open var disabledColor: UIColor = .clear {
        didSet {
            style.disabledColor = disabledColor
            self.reloadData()
        }
    }
    
    @IBInspectable open var disabledBorderColor: UIColor = .lightGray {
        didSet {
            style.disabledBorderColor = disabledBorderColor
            self.reloadData()
        }
    }
    
    @IBInspectable open var disabledFontColot: UIColor = .lightGray {
        didSet {
            style.disabledFontColot = disabledFontColot
            self.reloadData()
        }
    }
    
    @IBInspectable open var itemHeight: CGFloat = ESChipView.itemHeight {
        didSet {
            ESChipView.itemHeight = itemHeight; self.reloadData()
            self.reloadData()
        }
    }
    
    @IBInspectable open var padding: CGFloat = ESChipView.padding {
        didSet {
            ESChipView.padding = padding
            self.reloadData()
        }
    }
    
    
    @IBInspectable open var allowMultiSelection: Bool = true {
        didSet {
            self.allowsMultipleSelection = allowMultiSelection
            self.reloadData()
        }
    }
    
    
    public static var itemHeight: CGFloat = 35.0
    public static var padding: CGFloat = 10
    
    
    private var layout: AlignedCollectionViewFlowLayout {
        return self.collectionViewLayout as! AlignedCollectionViewFlowLayout
    }

    private var lastSelection: Int?
    
    open var items: [ESChipItemType] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    open var itemsString: [String] {
        return items.map({ $0.title })
    }
    
    open var disabledItems: [ESChipItemType] {
        return items.filter({ $0.status == .disabled })
    }
    
    open var selectedItems: [ESChipItemType] {
        return items.filter({ $0.status == .selected })
    }
    
    private var _selectedItems: [String] {
        return selectedItems.map({ $0.title })
    }
    
    private var _disabledItems: [String] {
        return disabledItems.map({ $0.title })
    }
    
    private var onSelectItem: ((_ item: ESChipItemType, _ index: Int)->())?
    private var onDeselectItem: ((_ item: ESChipItemType, _ index: Int)->())?
    
    
    open var style: Style = Style() {
        didSet {
            self.reloadData()
        }
    }
    
    
    
    override open var contentSize: CGSize {
        didSet {
            chipHeightConstraint.constant = contentSize.height
        }
    }
    
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
}

//MARK: - Public Helpers
public extension ESChipView {
    func select(_ item: String?) {
        if let index = items.firstIndex(where: { $0.title == item }) {
            self.lastSelection = index
            self.items[index].status = .selected
            self.reloadData()
        }
    }
    
    func select(itemAt index: Int) {
        if items.count > 0 && index < items.count {
            self.items[index].status = .selected
            self.lastSelection = index
            self.reloadData()
        }
    }
    
    func select(_ item: ESChipItemType) {
        select(item.title)
    }
    
    func selectedItem<T: ESChipItemType>(type: T.Type, _ handler: @escaping (_ item: T, _ index: Int) -> Void) {
        self.onSelectItem = { item, index in
            handler(item as! T, index)
        }
    }
    
    func unselectedItem<T: ESChipItemType>(type: T.Type, _ handler: @escaping (_ item: T, _ index: Int) -> Void) {
        self.onDeselectItem = { item, index in
            handler(item as! T, index)
        }
    }
    
    func clearSelections() {
        var newItems: [ESChipItemType] = []
        
        for item in items {
            var item = item
            item.status = .none
            newItems.append(item)
        }
        
        self.items = newItems
    }
}

//MARK: - Helpers
private extension ESChipView {
    func commonInit() {
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        self.allowsMultipleSelection = allowMultiSelection
        
        self.register(UINib(nibName: "ChipCollectionViewCell", bundle: currentBundle), forCellWithReuseIdentifier: "Cell")
        
        if #available(iOS 10.0, *) {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        } else {
            layout.estimatedItemSize = CGSize(width: ESChipView.itemHeight, height: ESChipView.itemHeight)
        }
        
        
        initLayout()
        
        mainQueue { [weak self] in
            guard let self = self else { return }
            self.reloadData()
        }
        
        if isIpad {
            delay(0.5) {
                mainQueue { [weak self] in
                    guard let self = self else { return }
                    self.reloadData()
                }
            }
        }
    }
    
    func initLayout() {
        layout.sectionInset = UIEdgeInsets.zero
        layout.horizontalAlignment = .leading
        layout.verticalAlignment = .center
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
    }
}

//MARK: - Delegate And Datasource
extension ESChipView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ChipCollectionViewCell
        if style.maxItemWidth == 0 { style.maxItemWidth = self.frame.width - 10 }
        cell.configure(for: items[indexPath.item], with: style)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if _selectedItems.contains(items[indexPath.item].title) {
            self.items[indexPath.item].status = .none
            self.lastSelection = nil
            onDeselectItem?(self.items[indexPath.item], indexPath.item)
            self.reloadData()
            return false
        }
        
        if _disabledItems.count > 0 && _disabledItems.contains(items[indexPath.item].title) {
            return false
        }
        
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainQueue { [weak self] in
            guard let self = self else { return }
            if let lastIndex = self.lastSelection, !self.allowMultiSelection {
                self.items[lastIndex].status = .none
            }
            
            self.items[indexPath.item].status = .selected
            self.lastSelection = indexPath.item
            self.onSelectItem?(self.items[indexPath.item], indexPath.item)
            self.reloadData()
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = currentBundle.loadNibNamed("ChipCollectionViewCell", owner: self, options: nil)?.last as! ChipCollectionViewCell
        if style.maxItemWidth == 0 { style.maxItemWidth = self.frame.width - 10 }
        cell.configure(for: items[indexPath.item], with: style)
        
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return CGSize(width: min(size.width, collectionView.frame.width - 10), height: size.height)
    }
    
}
