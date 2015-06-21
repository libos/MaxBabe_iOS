//
//  PreAboutController.swift
//  MaxBabe
//
//  Created by Liber on 6/21/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit

class PreAboutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func feedback(sender: AnyObject) {
        let vc = UMFeedback.feedbackModalViewController()
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func rateme(sender: AnyObject) {
        var url  = NSURL(string: "itms-apps://itunes.apple.com/app/id1010079070")
//        if UIApplication.sharedApplication().canOpenURL(url!) == true  {
            UIApplication.sharedApplication().openURL(url!)
//        }
        
    }
}

