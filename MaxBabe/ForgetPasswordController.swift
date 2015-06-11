//
//  ForgetPasswordController.swift
//  MaxBabe
//
//  Created by Liber on 6/11/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class ForgetPasswordController: UIQueryController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareRequest() {
        emailField.hidden = true
        findBtn.hidden = true
        super.prepareRequest()
    }
    
    override func failedRequest() {
        emailField.hidden = false
        findBtn.hidden = false
        super.failedRequest()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        self.email = emailField.text.stringByTrimmingLeadingAndTrailingWhitespace()
        
        if self.email == "" {
            warningShow("请先填写Email，还想不想找回了-_-!");
            return false
        }
        if !Global.isValidEmail(self.email!){
            warningShow("这不是邮箱-_-!，请填写您的注册邮箱");
            return false
        }
        prepareRequest()
        var auth:String = self.email! + ". maxtain . mybabe . forgetpassword "
        var params:Dictionary = ["email":self.email!,"auth":auth.md5]
        var query = QueryReg(params: params, type: QueryReg.QueryType.FORGET)
        query.start { (a_s) -> () in
            switch(a_s){
            case .CANCEL:
                self.failedRequest()
                self.warningShow("貌似出问题了Σ(⊙▽⊙\"a等下哈")
            case .NO_NETWORK:
                self.failedRequest()
                self.warningShow("请先联网后注册╥﹏╥");
            case .DATA_ERR:
                self.failedRequest()
                self.warningShow("开小差了，请稍后重试(ಥ_ಥ)");
            case .NO_USER:
                self.failedRequest()
                self.warningShow("无此邮箱o(╯□╰)o请填写您的注册邮箱")
            case .DATA_OK:
                self.failedRequest()
                self.performSegueWithIdentifier(identifier, sender: sender)
            default:
                self.failedRequest()
            }
        }
        
        
        return false
    }
    
}

