//
//  ShareTheme.swift
//  MaxBabe
//
//  Created by Liber on 6/14/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit


class UIShareTheme: UIView {
    
    
    let screen_size = UIScreen.mainScreen().bounds.size
    var itemsize:CGSize
    var dictOfElements:NSMutableDictionary
   
    var the_word:String
    var the_background:String
    var the_figure:String
    var weather = Weather.getInstance
    
    var hotSpot:UIButton = UIButton()
    var uiWord:UIView?
    var filepath:String?
    
    let centerx = Center.getInstance
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(xml:String,the_word:String?) {
        filepath = xml
        itemsize = CGSize(width: screen_size.width *  Global.SHARE_CARD_WIDTH_RATION, height: screen_size.height *  Global.SHARE_CARD_HEIGHT_RATION-36)
        dictOfElements = NSMutableDictionary()
        let st = NSUserDefaults.standardUserDefaults()
        if the_word == nil {
            self.the_word = st.stringForKey(Global.THE_WORD)!
        }else{
            self.the_word = the_word!
        }
        the_background = st.stringForKey(Global.THE_BACKGROUND)!
        the_figure = st.stringForKey(Global.THE_FIGURE)!
        
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: itemsize))
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSizeMake(0, 0)
        
        var err:NSErrorPointer = NSErrorPointer()
        var tbxml:TBXML = TBXML(XMLString: xml, error: err)
        if err != nil {
            println(err.memory?.description)
        }
        traverseElement( tbxml.rootXMLElement ,parent: self)
        
        self.addSubview(hotSpot)
        
//        if uiWord != nil {
////            let tmp = uiWord?.constraints()
//                hotSpot.frame = uiWord!.frame
//        }

        
    }
    deinit{
        
    }
    


    func getId(ele:UnsafeMutablePointer<TBXMLElement>)->String?{
        var attr:UnsafeMutablePointer<TBXMLAttribute> = ele.memory.firstAttribute
        if attr == nil {
            return nil
        }
        if TBXML.attributeName(attr) == "id"{
            return TBXML.attributeValue(attr)
        }
        while attr != nil {
            if TBXML.attributeName(attr) == "id"{
                return TBXML.attributeValue(attr)
            }
            attr = attr.memory.next
        }
        return nil
    }
    func getViewById(id:String) -> UIView{
      return dictOfElements.valueForKey(id) as! UIView
    }
    func toCGFloat(num:String) -> CGFloat{
        return CGFloat(NSNumberFormatter().numberFromString(num)!)
    }
    func doubleAttr(attr:String)->(UIView,CGFloat){
        let tmp:[String] = split(attr){$0 == ":"}
        return (getViewById(tmp[0]),toCGFloat(tmp[1]))
    }
    
    func tribleAttr(attr:String)->(String,UIView,CGFloat){
        let tmp:[String] = split(attr){$0 == ":"}
        return (tmp[0],getViewById(tmp[1]),toCGFloat(tmp[2]))
    }
    func processText(template:String) -> String{
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay, fromDate: now)
        
        return template.stringByReplacingOccurrencesOfString("{name}", withString: Center.getInstance.getUserName()).stringByReplacingOccurrencesOfString("{Y}", withString: "\(components.year)").stringByReplacingOccurrencesOfString("{m}", withString: "\(components.month)").stringByReplacingOccurrencesOfString("{d}", withString: "\(components.day)").stringByReplacingOccurrencesOfString("{city}", withString: centerx.s2t(City.getInstance.city_name)!)
    }
    
    func imageWidth(sourceImage:UIImage,i_width:CGFloat) -> UIImage {
        var oldWidth = sourceImage.size.width
        var scaleFactor = i_width / oldWidth
        var newHeight = sourceImage.size.height * scaleFactor
        var newWidth = oldWidth * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(newWidth,newHeight))
        sourceImage.drawInRect(CGRectMake(0,0,newWidth,newHeight))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
//    +(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
//    {
//    float oldWidth = sourceImage.size.width;
//    float scaleFactor = i_width / oldWidth;
//    
//    float newHeight = sourceImage.size.height * scaleFactor;
//    float newWidth = oldWidth * scaleFactor;
//    
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
//    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//    }
    func traverseElement(ele:UnsafeMutablePointer<TBXMLElement>, parent:UIView){
        var element = ele
        do{
            
            var elename = TBXML.elementName(element)
            var new_view:UIView?
            var isLabel:Bool = false
            var isWord:Bool = false
            var words:NSMutableAttributedString?
            var oRange:NSRange?
            if elename == "root"{
                new_view = self
            }else if elename == "div"{
                new_view = UIView()
            }else if elename == "word"{
                new_view  = UILabel()
                isLabel = true
                isWord = true
                var str = the_word
                if TBXML.textForElement(element) != "" {
                    str = the_word + "\n" + processText(TBXML.textForElement(element))
                }
                oRange = NSMakeRange(0, count(str))
                words = NSMutableAttributedString(string: centerx.s2t(str)!)
                (new_view as! UILabel).numberOfLines = 0
                (new_view as! UILabel).lineBreakMode = NSLineBreakMode.ByCharWrapping
            }else if elename == "background"{
                if NSFileManager().fileExistsAtPath(the_background) {
                    new_view =  UIImageView(image: UIImage(contentsOfFile: the_background)!)
                }else{
                    new_view =  UIImageView(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("daytime_clear01", ofType: "png")!)!)
                }
                (new_view as! UIImageView).contentMode = UIViewContentMode.ScaleAspectFill
                (new_view as! UIImageView).clipsToBounds = true
            }else if elename == "figure"{
                new_view = UIImageView(image: UIImage(contentsOfFile: the_figure))
                (new_view as! UIImageView).contentMode = UIViewContentMode.ScaleAspectFill
            }else if elename == "cityName"{
                new_view  = UILabel()
                var city = City.getInstance
                oRange = NSMakeRange(0, count(city.city_name!))
                words = NSMutableAttributedString(string: centerx.s2t(city.city_name)!)
                isLabel = true
            }else if elename == "date"{
                new_view  = UILabel()
       
                var tip = processText(TBXML.textForElement(element))
                
                oRange = NSMakeRange(0, count(tip))
                words = NSMutableAttributedString(string: centerx.s2t(tip)!)
                isLabel = true
            }else if elename == "temperature"{
                new_view  = UILabel()
                var weatherTemp = "0°"
                if weather.getTemp() != nil {
                    weatherTemp = "\(weather.getTemp()!)°"
                }
                isLabel = true
                oRange = NSMakeRange(0, count(weatherTemp))
                words = NSMutableAttributedString(string: weatherTemp)
                (new_view as! UILabel).attributedText = words
            }else if elename == "weather"{
                new_view  = UILabel()
                var weatherText = "晴"
                if weather.getWeather() != nil {
                    weatherText = "\(weather.getWeather()!)"
                }
                oRange = NSMakeRange(0, count(weatherText))
                words = NSMutableAttributedString(string: centerx.s2t(weatherText)!)
                isLabel = true
            }else if elename == "weatherIcon"{
                var weatherText = "晴"
                if weather.getWeather() != nil {
                    weatherText = "\(weather.getWeather()!)°"
                }
                new_view = UIImageView(image: Center.getInstance.getWeatherIcon(weatherText))
            }else if elename == "appIcon" {
                new_view = UIImageView(image: UIImage(named: "iconapp"))
                (new_view as! UIImageView).contentMode = UIViewContentMode.ScaleAspectFit
                (new_view as! UIImageView).layer.cornerRadius = 10
                (new_view as! UIImageView).clipsToBounds = true
            }else if elename == "appName" {
                new_view  = UILabel()
                oRange = NSMakeRange(0, count("麦宝星"))
                words = NSMutableAttributedString(string: centerx.s2t("麦宝星")!)
                isLabel = true
            }else if elename == "appDescription" {
                new_view  = UILabel()
                oRange = NSMakeRange(0, count("史上最萌的天气预报"))
                words = NSMutableAttributedString(string: centerx.s2t("史上最萌的天气预报")!)
                isLabel = true
            }else if elename == "p"{
                new_view  = UILabel()
                var text = processText(TBXML.textForElement(element))
                oRange = NSMakeRange(0, count(text))
                words = NSMutableAttributedString(string: centerx.s2t(text)!)
                (new_view as! UILabel).numberOfLines = 0
                isLabel = true
            }else{
                
            }
            if new_view != self {
                new_view?.setTranslatesAutoresizingMaskIntoConstraints(false)
                parent.addSubview(new_view!)
            }
            var attr:UnsafeMutablePointer<TBXMLAttribute> = element.memory.firstAttribute
            while attr != nil {
                var attr_name = TBXML.attributeName(attr)
                var attr_value = TBXML.attributeValue(attr)
                if attr_name == "id" {
                    dictOfElements.setValue(new_view, forKey: attr_value)
                }else if attr_name == "width"{
                    if attr_value.startWith("full") {
                        var xatr = tribleAttr(attr_value)
                        if xatr.0 == "full%"{
                            self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: xatr.1, attribute: NSLayoutAttribute.Width, multiplier: xatr.2, constant: 0))
                        }else{
                            self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: xatr.1, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: xatr.2))
                        }
                    }else if attr_value == "wrap"{
                        
                    }else{
                        new_view!.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: toCGFloat(attr_value)))
                    }
                }else if attr_name == "height"{
                    if attr_value.startWith("full") {
                        var xatr = tribleAttr(attr_value)
                        if xatr.0 == "full%"{
                            self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: xatr.1, attribute: NSLayoutAttribute.Height, multiplier: xatr.2, constant: 0))
                        }else{
                            self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: xatr.1, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: xatr.2))
                        }
                    }else if attr_value == "wrap"{
                        
                    }else{
                        new_view!.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: toCGFloat(attr_value)))
                    }
                }else if attr_name == "horizon"{
                    if attr_value.startWith("centerX") {
                        var xatr = tribleAttr(attr_value)
                        self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: xatr.1, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: xatr.2))
                    }else{
                        self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: toCGFloat(attr_value)))
                    }
                }else if attr_name == "vertical"{
                    
                    if attr_value.startWith("centerY") {
                        var xatr = tribleAttr(attr_value)
                        self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: xatr.1, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: xatr.2))
                    }else{
                        self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: toCGFloat(attr_value)))
                    }
                    
                }else if attr_name == "belowOf"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: xatr.1))
                }else if attr_name == "aboveOf"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: xatr.1))
                }else if attr_name == "leftOf"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: xatr.1))
                }else if attr_name == "rightOf"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: xatr.1))
                }else if attr_name == "margin_left"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: xatr.1))
                }else if attr_name == "margin_top"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: xatr.1))
                }else if attr_name == "margin_right"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -xatr.1))
                }else if attr_name == "margin_bottom"{
                    var xatr = doubleAttr(attr_value)
                    self.addConstraint(NSLayoutConstraint(item: new_view!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: xatr.0, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -xatr.1))
                }
                
                if isLabel{
                    if attr_name == "color"{
                        words!.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgba: attr_value), range: oRange!)
                    }else if attr_name == "align"{
                        var linestyle = words?.attribute(NSParagraphStyleAttributeName, atIndex: 0, effectiveRange: nil) as? NSMutableParagraphStyle
                        if linestyle == nil {
                            linestyle = NSMutableParagraphStyle()
                        }
                        if attr_value == "center"   {
                            linestyle!.alignment = NSTextAlignment.Center
                        }else if attr_value == "left"{
                            linestyle!.alignment = NSTextAlignment.Left
                        }else if attr_value == "right"{
                            linestyle!.alignment = NSTextAlignment.Right
                        }else {
                            linestyle!.alignment = NSTextAlignment.Center
                        }
                        words!.addAttribute(NSParagraphStyleAttributeName, value: linestyle!, range: oRange!)
                    }else if attr_name == "lineHeight"{
                        var linestyle = words?.attribute(NSParagraphStyleAttributeName, atIndex: 0, effectiveRange: nil) as? NSMutableParagraphStyle
                        if linestyle == nil {
                            linestyle = NSMutableParagraphStyle()
                        }
                        linestyle!.lineHeightMultiple = toCGFloat(attr_value)
                        words!.addAttribute(NSParagraphStyleAttributeName, value: linestyle!, range: oRange!)
                        
                    }else if attr_name == "font"{
                        let tmp:[String] = split(attr_value){$0 == ":"}
                        var font = UIFont(name: tmp[0], size: toCGFloat(tmp[1]))
                        if font == nil{
                            font = UIFont.systemFontOfSize(toCGFloat(tmp[1]))
                        }
                        words!.addAttribute(NSFontAttributeName, value: font!, range: oRange!)
                    }else if attr_name == "shadow"{
                        if attr_value == "default" {
                            new_view!.layer.shadowColor = UIColor.blackColor().CGColor
                            new_view!.layer.shadowRadius = 6.0
                            new_view!.layer.shadowOpacity = 0.5
                            new_view!.layer.shadowOffset = CGSizeMake(0, 0)
                        }else{
                            let tmp:[String] = split(attr_value){$0 == ":"}
                            new_view!.layer.shadowColor = UIColor(rgba: tmp[0]).CGColor
                            new_view!.layer.shadowRadius = toCGFloat(tmp[1])
                            new_view!.layer.shadowOpacity = Float(tmp[2].toInt()!)
                            new_view!.layer.shadowOffset = CGSizeMake(0, 0)
                        }
                    }
                }
                attr = attr.memory.next
            }
            
            if isLabel {
                (new_view as! UILabel).attributedText = words
            }
            if isWord {
                uiWord = new_view
            }
            if element.memory.firstChild != nil{
                traverseElement(element.memory.firstChild,parent: new_view!)
            }
            
            element = element.memory.nextSibling
        }while(element != nil)
        
    }
    
}