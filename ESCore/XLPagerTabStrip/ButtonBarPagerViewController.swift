//
//  ButtonBarPagerViewController.swift
//  ESCore
//
//  Created by Eslam Hanafy on 2/3/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

#if canImport(XLPagerTabStrip)
import UIKit
import XLPagerTabStrip

open class ButtonBarPagerViewController: ButtonBarPagerTabStripViewController {

    open var selectedColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.17)
    
    open var tabs: [UIViewController] = []
    
    
    
    override open func viewDidLoad() {
        fixPagerTab()
        super.viewDidLoad()
        if isRTL { tabs.reverse() }
    }
    

    override open func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return isRTL ? tabs.reversed() : tabs
    }

    
    override open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
      let size = super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
      let additional = indexPath.row == 0 ? CGFloat(0.000001) : CGFloat(0)
      return CGSize(width: size.width + additional, height: size.height)
    }
    
    
    func fixPagerTab() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = Fonts.bold(ofSize: 18)
        settings.style.buttonBarItemLeftRightMargin = 8
        settings.style.buttonBarRightContentInset = 8
        settings.style.buttonBarLeftContentInset = 8
        settings.style.selectedBarHeight = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard let self = self else { return }
            guard changeCurrentIndex == true else { return }
            
            //change contentview and textlabel colors
            oldCell?.contentView.backgroundColor = .clear
            newCell?.contentView.backgroundColor = self.selectedColor
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            }
            else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        
        if isRTL {
            delay(0.2) { [weak self] in
                guard let self = self else { return }
                self.moveToViewController(at: self.tabs.count - 1, animated: false)
            }
        }
    }
}
#endif
