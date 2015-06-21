//
//  SettingController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class SettingController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var accountBtn: UIButton!
    
    let center = Center.getInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if center.isLogin() {
            loginBtn.hidden = true
            loginImage.hidden = true
            accountBtn.hidden = false
            accountBtn.setTitle(center.account_nickname, forState: UIControlState.Normal)
        }else{
            loginBtn.hidden = false
            loginImage.hidden = false
            accountBtn.hidden = true
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func loggedBackUnwindSegue(segue:UIStoryboardSegue){
        if center.isLogin() {
            loginBtn.hidden = true
            loginImage.hidden = true
            accountBtn.hidden = false
            accountBtn.setTitle(center.account_nickname, forState: UIControlState.Normal)
        }else{
            loginBtn.hidden = false
            loginImage.hidden = false
            accountBtn.hidden = true
        }

    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        println("hhh")
        return true
    }
    @IBAction func LogoutUnwindSegue(segue:UIStoryboardSegue){
        var source:UIViewController = segue.sourceViewController as! UIViewController
        
        if source.isKindOfClass(AccountController){
            center.logout()
        }
        
        if center.isLogin() {
            loginBtn.hidden = true
            loginImage.hidden = true
            accountBtn.hidden = false
            accountBtn.setTitle(center.account_nickname, forState: UIControlState.Normal)
        }else{
            loginBtn.hidden = false
            loginImage.hidden = false
            accountBtn.hidden = true
        }

    }
}

