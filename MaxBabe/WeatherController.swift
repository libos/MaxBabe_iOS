//
//  WeatherController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class WeatherController: UIViewController {

    @IBOutlet weak var swPushNotice: UISwitch!
    
    @IBOutlet weak var swAutoUpdate: UISwitch!
    
    @IBOutlet weak var swNotification: UISwitch!
    @IBOutlet weak var swOnlyWifi: UISwitch!
    @IBOutlet weak var viewNegtive: UIView!
    @IBOutlet weak var swNegative: UISwitch!
    @IBOutlet weak var swGPSLocating: UISwitch!
    
    @IBOutlet weak var viewNotification: UIView!
    let center = Center.getInstance
    var st = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swPushNotice.on = st.boolForKey(Global.SETTING_SWITCH_PUSH_NOTICE)
        swAutoUpdate.on = st.boolForKey(Global.SETTING_SWITCH_AUTOUPDATE)
        swNotification.on = st.boolForKey(Global.SETTING_SWITCH_NOTIFICATION)
        swOnlyWifi.on = st.boolForKey(Global.SETTING_SWITCH_ONLYWIFI)
        swGPSLocating.on = st.boolForKey(Global.SETTING_SWITCH_GPS_LOCATING)
        
        swPushNotice.uiProper()
        swAutoUpdate.uiProper()
        swNotification.uiProper()
        swOnlyWifi.uiProper()
        swNegative.uiProper()
        swGPSLocating.uiProper()

        viewNegtive.hidden = true
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
        st.synchronize()
        self.navigationController?.popViewControllerAnimated(true)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func uiUpdate(sender: UISwitch) {
        sender.tintColor = UIColor.clearColor()

        if !sender.on {
            sender.backgroundColor = UIColor(white: 255, alpha: 0.4)
            sender.layer.cornerRadius = 16.0
        }else{
            sender.backgroundColor = UIColor.clearColor()
        }
    }

    @IBAction func swPushChanged(sender: AnyObject) {
        st.setBool(swPushNotice.on, forKey: Global.SETTING_SWITCH_PUSH_NOTICE)

    }
    
 
    @IBAction func swAutoUpdateChanged(sender: AnyObject) {
        st.setBool(swAutoUpdate.on, forKey: Global.SETTING_SWITCH_AUTOUPDATE)
    }

    @IBAction func swOnlyWifiChanged(sender: AnyObject) {
        st.setBool(swOnlyWifi.on, forKey: Global.SETTING_SWITCH_ONLYWIFI)
    }
    
    @IBAction func swNotificationChanged(sender: AnyObject) {
        st.setBool(swNotification.on, forKey: Global.SETTING_SWITCH_NOTIFICATION)
    }
    
    @IBAction func swGPSLocatingChanged(sender: AnyObject) {
        st.setBool(swGPSLocating.on, forKey: Global.SETTING_SWITCH_GPS_LOCATING)
    }
    @IBAction func swNegativeChanged(sender: AnyObject) {
        st.setBool(swNegative.on, forKey: Global.SETTING_SWITCH_NEGATIVE)
    }
}

