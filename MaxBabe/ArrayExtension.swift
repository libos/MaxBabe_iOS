//
//  ArrayExtension.swift
//  MaxBabe
//
//  Created by Liber on 6/17/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

extension Array{
    func average() -> Int {
        var sum:Int = 0
        for number in self {
            sum = sum + (number as! Int)
        }
        var  ave : Double = Double(sum) / Double(self.count)
        return Int(ceil(ave))
    }
}