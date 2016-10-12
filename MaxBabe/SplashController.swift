//
//  SplashController.swift
//  MaxBabe
//
//  Created by Liber on 5/26/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit

class SplashController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        // Show the home screen after a bit. Calls the show() function.
        let timer = NSTimer.scheduledTimerWithTimeInterval(
            0.5, target: self, selector: Selector("show"), userInfo: nil, repeats: false
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func show() {
        if NSUserDefaults.standardUserDefaults().boolForKey(Global.isFirstStart){
//        if false{
           self.performSegueWithIdentifier("showApp", sender: self)
        }else{

            self.performSegueWithIdentifier("toFirstStart", sender: self)
        }
    }

    func addBackgroundImage() {
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        
//        let bg = UIImage(named: "LaunchImage")
//        let bgView = UIImageView(image: bg)
//        bgView.contentMode = UIViewContentMode.Center
//        bgView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
//        self.view.addSubview(bgView)
    }
    
}

