//
//  RegisterSubmitController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class RegisterSubmitController: UIQueryController {

    @IBOutlet weak var boyBtn: UIButton!
    @IBOutlet weak var girlBtn: UIButton!
    
    var isBoy:Bool = true
    var email:String?
    var password:String?
    var phone:String?
    var nickname:String?
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var sexView: UIView!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        self.phone = phoneField.text.stringByTrimmingLeadingAndTrailingWhitespace()
        self.nickname = nicknameField.text.stringByTrimmingLeadingAndTrailingWhitespace()
        var sex:String = "0"
        if isBoy{
            sex = "1"
        }
        let nick_len:Int = count(self.nickname!)
        if (nick_len < 2 || nick_len > 24) {
            warningShow("昵称长度需要大于1位，小于24位(◡‿◡)")
            return false
        }
        if !Global.isValidPhoneNumber(self.phone!) || (count(self.phone!) < 8) {
                warningShow("您的手机号不正确(◡‿◡)")
                return false
        }
        prepareRequest()
        var auth : String =  self.email! + ". maxtain . mybabe " + self.password!
        var params:Dictionary = ["email":self.email!,"password":password,"auth":auth.md5,"phone":self.phone,"nick":self.nickname,"sex":sex]
        var query = QueryReg(params: params, type: QueryReg.QueryType.REGISTER)
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
                var st = NSUserDefaults.standardUserDefaults()
                st.setObject(self.email, forKey: Global.ACCOUNT_EMAIL)
                st.setObject(self.phone, forKey: Global.ACCOUNT_PHONE)
                st.setObject(self.nickname, forKey: Global.ACCOUNT_NICKNAME)
                if self.isBoy {
                    st.setObject("男", forKey: Global.ACCOUNT_SEX)
                }else{
                    st.setObject("女", forKey: Global.ACCOUNT_SEX)
                }
                st.synchronize()
                // delegate set value kill
                // dismiss
                self.performSegueWithIdentifier(identifier, sender: sender)
            case .DUPLICATE:
                self.failedRequest()
                self.warningShow("该手机号已经存在(T_T)，请重新输入");
                
            default:
                self.failedRequest()
            }
        }
        
        return false
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        var vw:AccountController = (segue.destinationViewController as! AccountController)
        
        vw.email = self.email!
        vw.nickname = self.nickname!
        vw.phone = self.phone
        if isBoy {
            vw.sex = "男"
        }else{
            vw.sex = "女"
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func boyOnClick(sender: AnyObject) {
        boyBtn.setImage( UIImage(named: "btn_gender_boy_check"), forState: UIControlState.Normal)
        girlBtn.setImage(UIImage(named: "btn_gender_girl_uncheck"), forState: UIControlState.Normal)
        isBoy = true
    }
    @IBAction func girlOnClick(sender: AnyObject) {
        boyBtn.setImage( UIImage(named: "btn_gender_boy_uncheck"), forState: UIControlState.Normal)
        girlBtn.setImage(UIImage(named: "btn_gender_girl_check"), forState: UIControlState.Normal)
        isBoy = false
    }
    
    override func prepareRequest(){
        phoneView.hidden = true
        nicknameView.hidden = true
        sexView.hidden = true
        doneBtn.hidden = true
        super.prepareRequest()
    }
    
    override func failedRequest(){
        phoneView.hidden = false
        nicknameView.hidden = false
        sexView.hidden = false
        doneBtn.hidden = false
        super.failedRequest()
    }
    
    
    
    
    
}

