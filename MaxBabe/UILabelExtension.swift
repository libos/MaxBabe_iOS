//
//  UILabelExtension.swift
//  MaxBabe
//
//  Created by Liber on 6/16/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit

extension UILabel{
    func sizeToFitMultipleLines(){
        if self.adjustsFontSizeToFitWidth {
            var adjustedFont:UIFont = self.attributedText.fontSizeWithFont( constrainedToSize: self.frame.size, minimumScaleFactor: self.minimumScaleFactor)
            var mas = NSMutableAttributedString(attributedString: self.attributedText)
            mas.setAttributes([NSFontAttributeName:adjustedFont], range: NSRangeFromString(self.attributedText.string))
            self.attributedText = mas
        }
        self.sizeToFit()
    }
}

extension NSAttributedString {
    func fontSizeWithFont(constrainedToSize size:CGSize,minimumScaleFactor:CGFloat)-> UIFont {
        var font = self.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as! UIFont
        
        var minimumFontSize:CGFloat = font.pointSize * minimumScaleFactor
        var fontSize:CGFloat = font.pointSize
        
        var attributedText = self
        
        var height:CGFloat = attributedText.boundingRectWithSize(CGSize(width: size.width,height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size.height
        
        var newFont = font
        
        while (height > size.height && height != 0 && fontSize > minimumFontSize) {
            fontSize -= 1
            
            newFont = UIFont(name: font.fontName, size: fontSize)!
            
            attributedText = NSAttributedString(string: self.string, attributes:
                [NSFontAttributeName:newFont])
            
            height = attributedText.boundingRectWithSize(CGSize(width: size.width,height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size.height
        }
        
        for word:NSString in self.string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()){
            var width = word.sizeWithAttributes([NSFontAttributeName:newFont]).width
            while width > size.width && width != 0 && fontSize > minimumFontSize {
                fontSize -= 1
                newFont = UIFont(name: font.fontName, size: fontSize)!
                width = word.sizeWithAttributes([NSFontAttributeName:newFont]).width
            }
        }
        return  UIFont(name: font.fontName, size: fontSize)!
    }
}