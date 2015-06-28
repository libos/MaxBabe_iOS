//
//  LoginChooseController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class LoginChooseController: UIViewController {

    @IBOutlet weak var lbWTF: UILabel!
    @IBOutlet weak var lbFuckCook: UILabel!
    
    let center =  Center.getInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        var strW = center.s2t("怎么可以还没注册T_T\n注册即可分享每日心情哦")!
        var oRange = NSMakeRange(0, count(strW))
        var str = NSMutableAttributedString(string: strW)
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        str.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica Neue", size: 15)!, range: oRange)
        var linestyle = NSMutableParagraphStyle()
        linestyle.lineHeightMultiple = 1.42
        linestyle.alignment = NSTextAlignment.Center
        str.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
        lbWTF.attributedText =  str
        
        strW = center.s2t("有账号了？\n那等什么，还不登录！")!
        oRange = NSMakeRange(0, count(strW))
        str = NSMutableAttributedString(string: strW)
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        str.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica Neue", size: 15)!, range: oRange)
        linestyle = NSMutableParagraphStyle()
        linestyle.lineHeightMultiple = 1.42
        linestyle.alignment = NSTextAlignment.Center
        str.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
        lbFuckCook.attributedText =  str
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelledUnwindSegue(segue:UIStoryboardSegue){
        
    }
}

