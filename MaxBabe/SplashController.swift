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
        Center.getInstance.start()
        addBackgroundImage()
//        addLogo()
        // Show the home screen after a bit. Calls the show() function.
        let timer = NSTimer.scheduledTimerWithTimeInterval(
            0.5, target: self, selector: Selector("show"), userInfo: nil, repeats: false
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func show() {
        self.performSegueWithIdentifier("showApp", sender: self)
    }

    func addBackgroundImage() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let bg = UIImage(named: "splash.png")
        let bgView = UIImageView(image: bg)
        
        bgView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        self.view.addSubview(bgView)
    }
    
//    func addLogo() {
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        
//        let logo     = UIImage(named: "AppIcon")
//        let logoView = UIImageView(image: logo)
//        
//        let w = logo?.size.width
//        let h = logo?.size.height
//        
//        logoView.frame = CGRectMake( (screenSize.width/2) - (w!/2), 5, w!, h! )
//        self.view.addSubview(logoView)
//    }
}

