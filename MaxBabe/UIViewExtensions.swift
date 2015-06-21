//
//  UIViewExtensions.swift
//  MaxBabe
//
//  Created by Liber on 6/13/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

extension UIView {
    func screenshotImage(scale: CGFloat = 0.0) -> UIImage {
        println(frame.size)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func removeAllSubviews(){
        self.subviews.map { $0.removeFromSuperview() }
    }
}


extension UISwitch{
    
    func uiProper(){
        self.tintColor = UIColor.clearColor()
        if !self.on {
            self.backgroundColor = UIColor(white: 255, alpha: 0.4)
            self.layer.cornerRadius = 16.0
        }else{
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
}