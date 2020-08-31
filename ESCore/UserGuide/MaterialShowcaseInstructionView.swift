//
//  MaterialShowcaseInstructionView.swift
//  MaterialShowcase
//
//  Created by Andrei Tulai on 2017-11-16.
//  Copyright © 2017 Aromajoin. All rights reserved.
//

import Foundation
import UIKit

public class MaterialShowcaseInstructionView: UIView {
  
  internal static let PRIMARY_TEXT_SIZE: CGFloat = 20
  internal static let SECONDARY_TEXT_SIZE: CGFloat = 15
  internal static let PRIMARY_TEXT_COLOR = UIColor.white
  internal static let SECONDARY_TEXT_COLOR = UIColor.white.withAlphaComponent(0.87)
  internal static let PRIMARY_DEFAULT_TEXT = "Awesome action"
  internal static let SECONDARY_DEFAULT_TEXT = "Tap here to do some awesome thing"
  
  public var primaryLabel: UILabel!
  public var secondaryLabel: UILabel!
  
  // Text
  public var primaryText: String! {
    didSet {
        updateContent()
    }
  }
  public var secondaryText: String! {
    didSet {
        updateContent()
    }
  }
  public var primaryTextColor: UIColor!
  public var secondaryTextColor: UIColor!
  public var primaryTextSize: CGFloat!
  public var secondaryTextSize: CGFloat!
  public var primaryTextFont: UIFont?
  public var secondaryTextFont: UIFont?
  public var primaryTextAlignment: NSTextAlignment!
  public var secondaryTextAlignment: NSTextAlignment!
  
  public init() {
    // Create frame
    let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
    super.init(frame: frame)
    
    configure()
  }
    
  public override init(frame: CGRect) {
    super.init(frame: frame)
        
    configure()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Initializes default view properties
  fileprivate func configure() {
    setDefaultProperties()
  }
  
  fileprivate func setDefaultProperties() {
    // Text
    primaryTextColor = MaterialShowcaseInstructionView.PRIMARY_TEXT_COLOR
    secondaryTextColor = MaterialShowcaseInstructionView.SECONDARY_TEXT_COLOR
    primaryTextSize = MaterialShowcaseInstructionView.PRIMARY_TEXT_SIZE
    secondaryTextSize = MaterialShowcaseInstructionView.SECONDARY_TEXT_SIZE
  }
  
  /// Configures and adds primary label view
  private func addPrimaryLabel() {
    if primaryLabel != nil {
      primaryLabel.removeFromSuperview()
    }
    
    primaryLabel = UILabel()
    
    if let font = primaryTextFont {
      primaryLabel.font = font
    } else {
      primaryLabel.font = UIFont.boldSystemFont(ofSize: primaryTextSize)
    }
    primaryLabel.textColor = primaryTextColor
    primaryLabel.textAlignment = self.primaryTextAlignment ?? .left
    primaryLabel.numberOfLines = 0
    primaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    primaryLabel.text = primaryText
    primaryLabel.frame = CGRect(x: 0,
                                y: 0,
                                width: getWidth(),
                                height: 0)

    primaryLabel.sizeToFitHeight()
    addSubview(primaryLabel)
  }
  
  /// Configures and adds secondary label view
  private func addSecondaryLabel() {
    if secondaryLabel != nil {
      secondaryLabel.removeFromSuperview()
    }
    
    secondaryLabel = UILabel()
    if let font = secondaryTextFont {
      secondaryLabel.font = font
    } else {
      secondaryLabel.font = UIFont.systemFont(ofSize: secondaryTextSize)
    }
    secondaryLabel.textColor = secondaryTextColor
    secondaryLabel.textAlignment = self.secondaryTextAlignment ?? .left
    secondaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    secondaryLabel.text = secondaryText
    secondaryLabel.numberOfLines = 0
    
    secondaryLabel.frame = CGRect(x: 0,
                                  y: primaryLabel.frame.height + 10,
                                  width: getWidth(),
                                  height: 0)
    secondaryLabel.sizeToFitHeight()
    addSubview(secondaryLabel)
    frame = CGRect(x: frame.minX,
                   y: frame.minY,
                   width: frame.width,
                   height: primaryLabel.frame.height + secondaryLabel.frame.height + 10)
  }
  
  //Calculate width per device
  private func getWidth() -> CGFloat {
    //superview was left side
    if superview == nil {
        return frame.width - 2 * frame.minX
    }
    
    if (self.superview?.frame.origin.x)! < CGFloat(0) {
      return frame.width - (frame.minX/2)
    } else if ((self.superview?.frame.origin.x)! + (self.superview?.frame.size.width)! >
      UIScreen.main.bounds.width) { //superview was right side
      return (frame.width - frame.minX)/2
    }
    return frame.width - 2 * frame.minX
  }
  
  /// Overrides this to add subviews. They will be drawn when calling show()
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    updateContent()
  }
    
  private func updateContent() {
    addPrimaryLabel()
    addSecondaryLabel()
        
    subviews.forEach({$0.isUserInteractionEnabled = false})
  }
}
