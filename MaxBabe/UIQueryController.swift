//
//  QueryController.swift
//  MaxBabe
//
//  Created by Liber on 6/11/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class UIQueryController: UIViewController {
    
    var indicator:UIActivityIndicatorView?
    var loadingView:UIView?
    var loadingLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWithIndictor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func warningShow(msg:String){
        TSMessage.dismissActiveNotification()
        TSMessage.showNotificationInViewController(self, title: msg, subtitle: "", type: TSMessageNotificationType.Warning, duration: 10 , canBeDismissedByUser: true)
    }
    
    func initWithIndictor(){
        loadingView = UIView(frame: CGRectMake(75, 155, 170, 170))
        loadingView?.center = self.view.center
        loadingView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        loadingView?.clipsToBounds = true
        loadingView?.layer.cornerRadius = 10.0
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator?.frame = CGRectMake(65, 40, indicator!.bounds.size.width, indicator!.bounds.size.height)
        loadingView?.addSubview(indicator!)
        
        loadingLabel = UILabel(frame: CGRectMake(20, 115, 130, 22))
        loadingLabel?.backgroundColor = UIColor.clearColor()
        loadingLabel?.adjustsFontSizeToFitWidth = true
        loadingLabel?.text = "Loading..."
        loadingLabel?.textAlignment = NSTextAlignment.Center
        loadingLabel?.textColor = UIColor.whiteColor()
        loadingView?.addSubview(loadingLabel!)
        loadingView?.hidden = true
        self.view.addSubview(loadingView!)
        
    }
    
    
    func prepareRequest(){
        loadingView?.hidden = false
        indicator?.startAnimating()
    }
    
    func failedRequest(){
        indicator?.stopAnimating()
        loadingView?.hidden = true
    }
    
}