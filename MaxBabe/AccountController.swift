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
    
    
    var sex:String? = "男"
    var email:String? = "@maxtain.com"
//    var password:String? = ""
    var phone:String? = "152****6823"
    var nickname:String? = "Showbin"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbEmail.text = self.email
        self.lbNickname.text = self.nickname
        self.lbPhone.text = self.phone!.substringToIndex("abc".endIndex) + "****" + self.phone!.substringFromIndex("abcdefg".endIndex)
       
        self.lbSex.text = self.sex
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "to_account_view_from_login"
//        {
//            var source:LoginController = segue.sourceViewController as! LoginController
//            source.dismissViewControllerAnimated(true, completion: nil)
//        }
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

