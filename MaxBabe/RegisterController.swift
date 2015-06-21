//
//  RegisterController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class RegisterController: UIQueryController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var nextBut: UIButton!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var emailView: UIView!
   
    
    var email:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc:RegisterSubmitController = segue.destinationViewController as! RegisterSubmitController
        vc.email = self.email
        vc.password = self.password
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        email = emailField.text.stringByTrimmingLeadingAndTrailingWhitespace()
        password = pwdField.text.stringByTrimmingLeadingAndTrailingWhitespace()
        
        if email == nil || email == "" {
            warningShow("请先填写Email<(￣︶￣)>")
            return false
        }
        if !Global.isValidEmail(email!){
            warningShow("Email格式错误<(￣︶￣)>")
            return false
        }
        if password == nil || password == "" {
            warningShow("请先填写密码<(￣︶￣)>")
            return false
        }
        let ps_len = count(password!)
        if (ps_len < 6 || ps_len > 36) {
            warningShow("密码至少6位，少于36位(づ′▽`)づ")
            return false
        }
        prepareRequest()
        
        var auth : String =  email! + ". maxtain . mybabe . unique"
        var params:Dictionary = ["email":self.email!,"auth":auth.md5]
        var query = QueryReg(params: params, type: QueryReg.QueryType.UNIQUE)
        query.start { (a_s) -> () in
            switch(a_s){
            case .CANCEL:
                self.failedRequest()
                self.warningShow("貌似出问题了Σ(⊙▽⊙\"a")
            case .NO_NETWORK:
                self.failedRequest()
                self.warningShow("请先联网后注册╥﹏╥");
            case .DATA_ERR:
                self.failedRequest()
                self.warningShow("开小差了，请稍后重试(ಥ_ಥ)");
            case .DATA_OK:
                self.failedRequest()
                self.performSegueWithIdentifier(identifier, sender: sender)
            case .DUPLICATE:
                self.failedRequest()
                self.warningShow("该用户名已经存在(T_T)，请重新输入");

            default:
                self.failedRequest()
            }
        }
        return false
    }
    
    override func prepareRequest(){
        nextBut.hidden = true
        pwdView.hidden = true
        emailView.hidden = true
        super.prepareRequest()
    }
    
    override func failedRequest(){
        nextBut.hidden = false
        pwdView.hidden = false
        emailView.hidden = false
        super.failedRequest()
    }
    

}

