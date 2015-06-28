//
//  UIPtfView.swift
//  MaxBabe
//
//  Created by Liber on 6/22/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit


class UIPtfView: UIView,SSPullToRefreshContentView {
    
    var lbTip:UILabel
    var ivIcon:UIImageView
    var countOficon:UInt32
    var updateTime:NSDate?
    let centerx = Center.getInstance
    
    override init(frame: CGRect) {
        lbTip = UILabel()
        ivIcon = UIImageView()
        countOficon = UInt32(Global.weather_icon.count)
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        ivIcon.image = UIImage(named: Global.weather_icon[Int(arc4random_uniform(countOficon))])
        ivIcon.setTranslatesAutoresizingMaskIntoConstraints(false)

        var borderFrame:CGRect = CGRectMake(-7, -7, 46, 46)
        var borderLayer:CALayer = CALayer()
        borderLayer.frame = borderFrame
        borderLayer.cornerRadius = 23.0
        borderLayer.backgroundColor = UIColor.clearColor().CGColor
        borderLayer.borderWidth = 1.0
        borderLayer.borderColor = UIColor.whiteColor().CGColor
        borderLayer.masksToBounds = true
        ivIcon.layer.addSublayer(borderLayer)
        
        lbTip.setTranslatesAutoresizingMaskIntoConstraints(false)
        lbTip.textColor = UIColor.whiteColor()
        lbTip.font = UIFont.systemFontOfSize(8)
        lbTip.textAlignment = NSTextAlignment.Center
        self.addSubview(lbTip)
        self.addSubview(ivIcon)
        self.addConstraint(NSLayoutConstraint(item: ivIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 32))
        self.addConstraint(NSLayoutConstraint(item: ivIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 32))
        self.addConstraint(NSLayoutConstraint(item: ivIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: ivIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: lbTip, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: ivIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10))
        self.addConstraint(NSLayoutConstraint(item: lbTip, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: ivIcon, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setState(state: SSPullToRefreshViewState, withPullToRefreshView view: SSPullToRefreshView!) {
        
        switch state {
        case SSPullToRefreshViewState.Ready:
            lbTip.text = centerx.s2t("松开可以更新")!
        case SSPullToRefreshViewState.Normal:
            ivIcon.image = UIImage(named: Global.weather_icon[Int(arc4random_uniform(countOficon))])
//            ivIcon.image = UIImage(named: Global.weather_icon[0])
            lbTip.text = centerx.s2t("下拉更新")
        case SSPullToRefreshViewState.Loading:
            lbTip.text = centerx.s2t("加载中...")
            break
        case SSPullToRefreshViewState.Closing:
            break
            
        }
    }
    
    func setLastUpdatedAt(date: NSDate!, withPullToRefreshView view: SSPullToRefreshView!) {
        self.updateTime = date
    }
}
