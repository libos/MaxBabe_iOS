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
    override func viewDidLoad() {
        super.viewDidLoad()
        let strW = "怎么可以还没注册T_T\n注册即可分享每日心情哦"
        let oRange = NSMakeRange(0, count(strW))
        var str = NSMutableAttributedString(string: strW)
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        str.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(17), range: oRange)
        var linestyle = NSMutableParagraphStyle()
        linestyle.lineHeightMultiple = 1.42
        linestyle.alignment = NSTextAlignment.Center
        str.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
        lbWTF.attributedText =  str
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelledUnwindSegue(segue:UIStoryboardSegue){
        
    }
}

