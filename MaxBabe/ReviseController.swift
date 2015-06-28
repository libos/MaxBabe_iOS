//
//  ReviseController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class ReviseController: UIQueryController {

    enum ChangeType{
    case NICKNAME,SEX,PASSWORD,PHONE
    }
    
    var type:ChangeType = ChangeType.NICKNAME
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbRevised: UILabel!
    @IBOutlet weak var edRevised: UITextField!
    
    @IBOutlet weak var lbPwd: UILabel!
    @IBOutlet weak var edPwd: UITextField!
    
    @IBOutlet weak var boyBtn: UIButton!
    @IBOutlet weak var girlBtn: UIButton!
    
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var sexView: UIView!
    @IBOutlet weak var revisedView: UIView!

    var isBoy:Bool = true
    var revisedValue:String?
    var passwd:String?
    var center = Center.getInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sexView.hidden = true
        pwdView.hidden = false
        revisedView.hidden = false
        switch (type){
        case .NICKNAME:
            lbTitle.text = center.s2t("修改昵称")
            lbRevised.text = center.s2t("新昵称")
            edRevised.placeholder = "New Nickname"
            edRevised.secureTextEntry = false
            lbPwd.text = center.s2t("密　码")
            edPwd.secureTextEntry = true
            edPwd.placeholder = "Password"
        case .SEX:
            sexView.hidden = false
            pwdView.hidden = true
            lbTitle.text = center.s2t("修改性别")
            lbRevised.text = center.s2t("密　码")
            edRevised.placeholder = "Password"
            edRevised.secureTextEntry = true
            if Center.getInstance.account_sex == "男"{
                boyBtn.setImage( UIImage(named: "btn_gender_boy_check"), forState: UIControlState.Normal)
                girlBtn.setImage(UIImage(named: "btn_gender_girl_uncheck"), forState: UIControlState.Normal)
            }else{
                boyBtn.setImage( UIImage(named: "btn_gender_boy_uncheck"), forState: UIControlState.Normal)
                girlBtn.setImage(UIImage(named: "btn_gender_girl_check"), forState: UIControlState.Normal)
            }
        case .PASSWORD:
            lbTitle.text = center.s2t("修改密码")
            lbRevised.text = center.s2t("旧密码")
            edRevised.placeholder = "Old Password"
            edRevised.secureTextEntry = true
            lbPwd.text = center.s2t("新密码")
            edPwd.secureTextEntry = true
            edPwd.placeholder = "New Password"

        case .PHONE:
            lbTitle.text = center.s2t("修改手机号")
            lbRevised.text = center.s2t("新手机号")
            edRevised.placeholder = "New Phone"
            edRevised.keyboardType = UIKeyboardType.PhonePad
            edRevised.secureTextEntry = false
            lbPwd.text = center.s2t("密　　码")
            edPwd.secureTextEntry = true
            edPwd.placeholder = "Password"
        }
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        revisedValue = edRevised.text.stringByTrimmingLeadingAndTrailingWhitespace()
        passwd = edPwd.text.stringByTrimmingLeadingAndTrailingWhitespace()
        
        if type == ChangeType.PASSWORD {
            passwd = edRevised.text
            revisedValue = edPwd.text
        }

        if type == ChangeType.SEX {
            passwd = edRevised.text
            if isBoy {
                revisedValue = "1"
            }else{
                revisedValue = "0"
            }
        }
        
        if passwd == nil || passwd == "" {
            warningShow("先把密码填了-.-")
            return false
        }
        
        var old_ps_len:Int = count(passwd!);
        if (old_ps_len < 6 || old_ps_len > 36) {
            warningShow("密码至少6位，少于36位(づ′▽`)づ")
            return false
        }
        
        if !Global.isValidEmail(center.account_email!){
            warningShow("您还没有登录-.-");
            return false
        }
        
        if type == ChangeType.PASSWORD {
            var ps_len:Int = count(revisedValue!);
            if (ps_len < 6 || ps_len > 36) {
                warningShow("密码至少6位，少于36位(づ′▽`)づ");
                return false
            }
            if (revisedValue == passwd) {
                warningShow("新旧密码一样===(￣▽￣*)b");
                return false
            }
        }
        if revisedValue == nil || revisedValue == "" {
            warningShow("请填写内容===(￣▽￣*)b");
            return false
        }
        if type == ChangeType.NICKNAME {
            if revisedValue == self.center.account_nickname {
                warningShow("昵称一!模!一!样!(￣▽￣*)b")
                return false
            }
            let nick_len:Int = count(revisedValue!)
            if (nick_len < 2 || nick_len > 24) {
                warningShow("昵称长度需要大于1位，小于24位(◡‿◡)")
                return false
            }
        }
        if type == ChangeType.PHONE {
            if !Global.isValidPhoneNumber(revisedValue!) || (count(revisedValue!) < 8) {
                warningShow("您的手机号不正确(◡‿◡)")
                return false
            }
        }
        
        prepareRequest()
        var auth : String = center.account_email! + ". maxtain . mybabe . update " + passwd!
        var field_name:String
        switch(type){
        case .NICKNAME:
            field_name = "nick"
        case .SEX:
            field_name = "sex"
        case .PASSWORD:
            field_name = "new_password"
        case .PHONE:
            field_name = "phone"
        }
        var params:Dictionary = ["email":center.account_email!,"password":passwd,"auth":auth.md5,"field_name":field_name,"field_value":revisedValue]
        var query = QueryReg(params: params, type: QueryReg.QueryType.UPDATE)
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
            case .DUPLICATE:
                self.failedRequest()
                self.warningShow("手机号已有人在使用(｡•ˇ‸ˇ•｡)");
            case .NO_USER:
                self.failedRequest()
                self.warningShow("密码错误o(╯□╰)o")
            case .UPDATE_DONE:
                let st = NSUserDefaults.standardUserDefaults()
                switch(self.type){
                case .NICKNAME:
                    self.center.account_nickname = self.revisedValue!
                    st.setObject(self.revisedValue!, forKey: Global.ACCOUNT_NICKNAME)
                case .SEX:
                    if self.isBoy {
                        self.center.account_sex = "男"
                        st.setObject("男", forKey: Global.ACCOUNT_SEX)
                    }else{
                        self.center.account_sex = "女"
                        st.setObject("女", forKey: Global.ACCOUNT_SEX)
                    }
                case .PASSWORD:
                    field_name = "new_password"
                case .PHONE:
                    self.center.account_phone = self.revisedValue!
                    st.setObject(self.revisedValue!, forKey: Global.ACCOUNT_PHONE)
                }
                self.failedRequest()
                self.performSegueWithIdentifier(identifier, sender: sender)
            default:
                self.failedRequest()
            }
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func boyOnChecked(sender: AnyObject) {
        
    }
}

