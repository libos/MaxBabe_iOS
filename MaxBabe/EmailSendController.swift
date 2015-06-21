//
//  EmailSendController.swift
//  MaxBabe
//
//  Created by Liber on 6/11/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class EmailSendController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }

    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

   }
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

   }


