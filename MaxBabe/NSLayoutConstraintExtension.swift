//
//  NSLayoutConstraintExtension.swift
//  MaxBabe
//
//  Created by Liber on 6/13/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

extension NSLayoutConstraint {
    class func applyAutoLayout(superview: UIView, target: UIView, index: Int?, top: Float?, left: Float?, right: Float?, bottom: Float?, height: CGFloat?, width: CGFloat?) {
        
        target.setTranslatesAutoresizingMaskIntoConstraints(false)
        if let index = index {
            superview.insertSubview(target, atIndex: index)
        } else {
            superview.addSubview(target)
        }
        var verticalFormat = "V:"
        if let top = top {
            verticalFormat += "|-(\(top))-"
        }
        verticalFormat += "[target"
        if let height = height {
            verticalFormat += "(\(height))"
        }
        verticalFormat += "]"
        if let bottom = bottom {
            verticalFormat += "-(\(bottom))-|"
        }
        let verticalConstrains = NSLayoutConstraint.constraintsWithVisualFormat(verticalFormat, options: nil, metrics: nil, views: [ "target" : target ])
        superview.addConstraints(verticalConstrains)
        
        var horizonFormat = "H:"
        if let left = left {
            horizonFormat += "|-(\(left))-"
        }
        horizonFormat += "[target"
        if let width = width {
            horizonFormat += "(\(width))"
        }
        horizonFormat += "]"
        if let right = right {
            horizonFormat += "-(\(right))-|"
        }
        let horizonConstrains = NSLayoutConstraint.constraintsWithVisualFormat(horizonFormat, options: nil, metrics: nil, views: [ "target" : target ])
        superview.addConstraints(horizonConstrains)
    }
}