//
//  StringExtensions.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation
extension String{
    var md5 : String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strlen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestlen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestlen)
        CC_MD5(str!,strlen,result)
        
        var hash = NSMutableString()
        
        for i in  0..<digestlen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestlen)
        
        return String(format: hash as String)
    }
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}