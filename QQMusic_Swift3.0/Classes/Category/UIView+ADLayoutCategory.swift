//
//  UIView+ADLayoutCategory.swift
//  ADLayout
//
//  Created by Yue Zhou on 7/22/17.
//  Copyright © 2017 Yue Zhou. All rights reserved.
//

import UIKit

public enum AD_Align {
    case topLeft
    case topRight
    case topCenter
    case bottomLeft
    case bottomRight
    case bottomCenter
    case centerLeft
    case centerRight
    case center
    
    fileprivate func layoutAttributes(isInner: Bool, isVertical: Bool) -> AD_LayoutAttribute {
        let attrs = AD_LayoutAttribute()
        
        switch self {
            case .topLeft:
                _ = attrs.horizontals(from: .left, to: .left).verticals(from: .top, to: .top)
                if isInner {
                    return attrs
                } else if isVertical {
                    return attrs.verticals(from: .bottom, to: .top)
                } else {
                    return attrs.horizontals(from: .right, to: .left)
                }
            
            case .topRight:
                _ = attrs.horizontals(from: .right, to: .right).verticals(from: .top, to: .top)
                if isInner {
                    return attrs
                } else if isVertical {
                    return attrs.verticals(from: .bottom, to: .top)
                } else {
                    return attrs.horizontals(from: .left, to: .right)
                }
            
            case .bottomLeft:
                _ = attrs.horizontals(from: .left, to: .left).verticals(from: .bottom, to: .bottom)
                
                if isInner {
                    return attrs
                } else if isVertical {
                    return attrs.verticals(from: .top, to: .bottom)
                } else {
                    return attrs.horizontals(from: .right, to: .left)
                }
            
            case .bottomRight:
                _ = attrs.horizontals(from: .right, to: .right).verticals(from: .bottom, to: .bottom)
                
                if isInner {
                    return attrs
                } else if isVertical {
                    return attrs.verticals(from: .top, to: .bottom)
                } else {
                    return attrs.horizontals(from: .left, to: .right)
                }
            
            
            case .topCenter:
                _ = attrs.horizontals(from: .centerX, to: .centerX).verticals(from: .top, to: .top)
                return isInner ? attrs : attrs.verticals(from: .bottom, to: .top)
            
            case .bottomCenter:
                _ = attrs.horizontals(from: .centerX, to: .centerX).verticals(from: .bottom, to: .bottom)
                return isInner ? attrs : attrs.verticals(from: .top, to: .bottom)
            
            case .centerLeft:
                _ = attrs.horizontals(from: .left, to: .left).verticals(from: .centerY, to: .centerY)
                return isInner ? attrs : attrs.horizontals(from: .right, to: .left)
            
            case .centerRight:
                _ = attrs.horizontals(from: .right, to: .right).verticals(from: .centerY, to: .centerY)
                return isInner ? attrs : attrs.horizontals(from: .left, to: .right)
            
            case .center:
                return AD_LayoutAttribute(horizontal: .centerX, referHorizontal: .centerX, vertical: .centerY, referVertical: .centerY)
        }
    }
}


extension UIView {
    /**
      Fill the super view with caller
      - parameter toFill: the superview to be filled up
      - returns: constraints
     */
    public func ad_fillSuper(_ toFill: UIView) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: ["subView": self])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: ["subView": self])
        superview?.addConstraints(cons)
        
        return cons
    }
    
    
    public func ad_alignInner(orientation: AD_Align, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        return ad_alignRelative(to: referView, attributes: orientation.layoutAttributes(isInner: true, isVertical: true), size: size, offset: offset)
    }
    
    
    public func ad_alignOuterHorizontal(orientation: AD_Align, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return ad_alignRelative(to: referView, attributes: orientation.layoutAttributes(isInner: false, isVertical: false), size: size, offset: offset)
    }
    
    
    /// tile the subviews inside the caller view
    public func ad_tileHorizontal(_ subviews: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        assert(!subviews.isEmpty, "the subviews must have at least one element.")
        
        var cons = [NSLayoutConstraint]()
        let first = subviews[0]
        _ = first.ad_alignInner(orientation: AD_Align.topLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: first, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        // append the other subviews' constraints
        var previous = first
        for i in 1..<subviews.count {
            let subview = subviews[i]
            cons += subview.ad_sizeConstraints(first)
            _ = subview.ad_alignOuterHorizontal(orientation: AD_Align.topRight, referView: previous, size: nil, offset: CGPoint(x: insets.right, y: 0))
            previous = subview
        }
        
        let last = subviews.last!
        cons.append(NSLayoutConstraint(item: last, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        addConstraints(cons)
        return cons
    }
    
    
    public func ad_VerticalTile(_ subviews: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!subviews.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let first = subviews[0]
        _ = first.ad_alignInner(orientation: AD_Align.topLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: first, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        var previous = first
        for i in 1..<subviews.count {
            let subview = subviews[i]
            cons += subview.ad_sizeConstraints(first)
            _ = subview.ad_alignOuterVertical(orientation: AD_Align.bottomLeft, referView: previous, size: nil, offset: CGPoint(x: 0, y: insets.bottom))
            previous = subview
        }
        
        let last = subviews.last!
        cons.append(NSLayoutConstraint(item: last, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        addConstraints(cons)
        return cons
    }
    
    
    /**
     * The caller is aligned vertically to a referview
     - parameter
     */
    public func ad_alignOuterVertical(orientation: AD_Align, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        return ad_alignRelative(to: referView, attributes: orientation.layoutAttributes(isInner: false, isVertical: true), size: size, offset: offset)
    }
    
    
    public func ad_showConstraint(_ constraints: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
    
    
    /**
     The caller is aligned based on attributes to a referview
     - parameter referView: the reference view
     - parameter attributes: attributes
     - parameter size: size of the caller
     - parameter offset: the offset of the caller to referview
     - returns: constraints
     */
    fileprivate func ad_alignRelative(to referView: UIView, attributes: AD_LayoutAttribute, size: CGSize?, offset: CGPoint) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        cons += ad_locationRelative(to: referView, attributes: attributes, offset: offset)
        
        if size != nil {
            cons += ad_sizeConstraints(size!)
        }
        
        superview?.addConstraints(cons)
        
        return cons
    }
    
    
    /// Returns the location constraints of the caller relative to a referview
    fileprivate func ad_locationRelative(to referView: UIView, attributes: AD_LayoutAttribute, offset: CGPoint) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.vertical, multiplier: 1.0, constant: offset.y))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        return cons
    }
    
    
    /// Returns the size constraints of the caller relative to a referview
    fileprivate func ad_sizeConstraints(_ referView: UIView) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0))
        
        return cons
    }
    
    
    // returns the size constraints of the caller
    fileprivate func ad_sizeConstraints(_ size: CGSize) -> [NSLayoutConstraint] {
        var cons = [NSLayoutConstraint]()
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height))
        return cons
    }
    
}

///  layout properties
private final class AD_LayoutAttribute {
    var horizontal:         NSLayoutAttribute
    var referHorizontal:    NSLayoutAttribute
    var vertical:           NSLayoutAttribute
    var referVertical:      NSLayoutAttribute
    
    init() {
        horizontal = NSLayoutAttribute.left
        referHorizontal = NSLayoutAttribute.left
        vertical = NSLayoutAttribute.top
        referVertical = NSLayoutAttribute.top
    }
    
    init(horizontal: NSLayoutAttribute, referHorizontal: NSLayoutAttribute, vertical: NSLayoutAttribute, referVertical: NSLayoutAttribute) {
        
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    fileprivate func horizontals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        horizontal = from
        referHorizontal = to
        
        return self
    }
    
    fileprivate func verticals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        vertical = from
        referVertical = to
        
        return self
    }
}
