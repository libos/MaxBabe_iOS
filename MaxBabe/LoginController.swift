//
//  LoginController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class LoginController: UIQueryController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var pwdField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    
    @IBOutlet weak var forgetBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    var username:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "to_account_view_from_login"{
            self.username = usernameField.text.stringByTrimmingLeadingAndTrailingWhitespace()
            self.password = pwdField.text.stringByTrimmingLeadingAndTrailingWhitespace()

            if self.username == "" {
                warningShow("请先填写用户名-_-!");
                return false
            }
            if self.password == "" {
                warningShow("请填写密码-_-!");
                return false
            }
            if !Global.isValidEmail(self.username!) && !Global.isValidPhoneNumber(self.username!){
                    warningShow("既不是邮箱也不是手机-_-!")
                    return false
            }
            prepareRequest()
            var auth : String =  self.username! + ". maxtain . mybabe . login " + self.password!
            
            var params:Dictionary = ["email":self.username!,"password":password,"auth":auth.md5]
            var query = QueryReg(params: params, type: QueryReg.QueryType.LOGIN)
            query.start({ (a_s) -> () in
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
                case .NO_USER:
                    self.failedRequest()
                    self.warningShow("用户名或密码错误o(╯□╰)o")
                case .LOGON:
                   self.failedRequest()
                   TSMessage.showNotificationInViewController(self, title: "成功登录", subtitle: "", type: TSMessageNotificationType.Success, duration: 10 , canBeDismissedByUser: true)
                    // delegate set value kill
                    // dismiss
                    self.performSegueWithIdentifier(identifier, sender: sender)
//                   self.dismissViewControllerAnimated(true, completion: { () -> Void in
//
//                   })
                    
//
                default:
                    self.failedRequest()

                }
            })
            
            return false
        }else if identifier == "to_forget_password_input_email"{
            return true
        }else{
            return true
        }
    }
    
    @IBAction func unwindToSegue(segue : UIStoryboardSegue){
        var sourceViewController:UIViewController = segue.sourceViewController as! UIViewController
        if sourceViewController.isKindOfClass(EmailSendController){
            println("haoshenqi ")
        }
    }

    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareRequest() {
        passwordView.hidden = true
        usernameView.hidden = true
        forgetBtn.hidden = true
        loginBtn.hidden = true
        super.prepareRequest()
    }
    
    override func failedRequest() {
        passwordView.hidden = false
        usernameView.hidden = false
        forgetBtn.hidden = false
        loginBtn.hidden = false
        super.failedRequest()
    }
    
}

