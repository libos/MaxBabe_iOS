//
//  CGRectExtension.swift
//  MaxBabe
//
//  Created by Liber on 6/18/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit

extension CGRect{
    
    func centerPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self))
    }

    func centerReversePoint(#height:CGFloat) -> CGPoint {
        return CGPointMake(CGRectGetMidX(self), height - CGRectGetMidY(self))
    }
}

