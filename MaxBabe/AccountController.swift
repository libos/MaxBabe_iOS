//
//  AccountController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class AccountController: UIViewController {

    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbNickname: UILabel!
    @IBOutlet weak var lbSex: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    
    var center = Center.getInstance
    
    var sex:String? = "男"
    var email:String? = "@maxtain.com"
//    var password:String? = ""
    var phone:String? = "152****6823"
    var nickname:String? = "Showbin"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sex = center.account_sex
        self.email = center.account_email
        self.phone = center.account_phone
        self.nickname = center.account_nickname
        
        self.lbEmail.text = self.email
        self.lbNickname.text = self.nickname
        self.lbPhone.text = self.phone!.substringToIndex("abc".endIndex) + "****" + self.phone!.substringFromIndex("abcdefg".endIndex)
        self.lbSex.text = self.sex
       
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
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "to_revise_name"{
            var revise:ReviseController = segue.destinationViewController as! ReviseController
            revise.type = ReviseController.ChangeType.NICKNAME
        }else if segue.identifier == "to_revise_sex" {
            var revise:ReviseController = segue.destinationViewController as! ReviseController
            revise.type = ReviseController.ChangeType.SEX
        }else if segue.identifier == "to_revise_password"{
            var revise:ReviseController = segue.destinationViewController as! ReviseController
            revise.type = ReviseController.ChangeType.PASSWORD
        }else if segue.identifier == "to_revise_phone"{
            var revise:ReviseController = segue.destinationViewController as! ReviseController
            revise.type = ReviseController.ChangeType.PHONE
        }
        
    }
    
    @IBAction func revisedBackUnwindSegue(segue:UIStoryboardSegue){
        self.sex = center.account_sex
        self.phone = center.account_phone
        self.nickname = center.account_nickname
        self.lbNickname.text = self.nickname
        self.lbPhone.text = self.phone!.substringToIndex("abc".endIndex) + "****" + self.phone!.substringFromIndex("abcdefg".endIndex)
        self.lbSex.text = self.sex
    }
    
    
    @IBAction func changeNickname(sender: AnyObject) {
        
    }
    @IBAction func changeSex(sender: AnyObject) {
        
    }
    @IBAction func changePassword(sender: AnyObject) {
        
    }
    @IBAction func changePhone(sender: AnyObject) {
        
    }
}

