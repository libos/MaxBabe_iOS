//
//  UIViewControllerExtensions.swift
//  MaxBabe
//
//  Created by Liber on 6/13/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation
extension UIViewController {
    func screenshotFromWindow(scale: CGFloat = 0.0) -> UIImage? {
        
        if let window = UIApplication.sharedApplication().windows.first as? UIWindow {
            UIGraphicsBeginImageContextWithOptions(window.frame.size, false, scale)
            window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        return nil
    }
}