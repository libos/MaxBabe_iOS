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
    
    func cleanCity() -> String{
        var ret_name:String = self
        for wd in ["市","市辖区","自治区", "自治州", "地区", "特别行政区"] {
            ret_name = ret_name.stringByReplacingOccurrencesOfString(wd, withString: "")
        }
        return ret_name
    }
    
    func startWith(prefix:String) -> Bool {
        if prefix.endIndex > self.endIndex {
            return false
        }
        if prefix.endIndex == self.endIndex{
            if self == prefix{
                return true
            }else{
                return false
            }
        }
//        let idx = min(prefix.endIndex,self.endIndex)
        if self.substringToIndex(prefix.endIndex) == prefix {
            return true
        }else{
            return false
        }
    }
    
    func substring(to:Int) -> String{
        var toEnd = count(self) - 1
        if to < toEnd {
            toEnd = to
        }
        return self.substringWithRange(Range<String.Index>(start: self.startIndex, end: advance(self.startIndex, toEnd)))
    }
    func trim() ->String{
        return self.stringByTrimmingLeadingAndTrailingWhitespace().stringByReplacingOccurrencesOfString("\r", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
        let leadingAndTrailingWhitespacePattern = "(?:^\\s+)|(?:\\s+$)"
        
        if let regex = NSRegularExpression(pattern: leadingAndTrailingWhitespacePattern, options: .CaseInsensitive, error: nil) {
            let range = NSMakeRange(0, count(self))
            let trimmedString = regex.stringByReplacingMatchesInString(self, options: .ReportProgress, range:range, withTemplate:"$1")
            
            return trimmedString
        } else {
            return self
        }
    }
    
      

}