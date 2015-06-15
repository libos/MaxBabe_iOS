//
//  ShareController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class ShareController: UIViewController {

    @IBOutlet weak var samsara: UIImageSamsaraView!
    
    var collections = [UIImage]()
    
    
    private let defaultInteractiveTransition = UIPercentDrivenInteractiveTransition()
    private var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private var animationController: UIViewControllerAnimatedTransitioning?
    private var edgeSwiping = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = UIScreen.mainScreen().bounds.size
        let item_size = CGSize(width: size.width * Global.SHARE_CARD_WIDTH_RATION, height: size.height * Global.SHARE_CARD_HEIGHT_RATION)

        var theme01 = UIShareTheme(xml: String(contentsOfFile: NSBundle.mainBundle().pathForResource("theme01", ofType: "xml")!, encoding: NSUTF8StringEncoding, error: nil)!)

        var theme02 = UIShareTheme(xml: String(contentsOfFile: NSBundle.mainBundle().pathForResource("theme02", ofType: "xml")!, encoding: NSUTF8StringEncoding, error: nil)!)
        theme01.backgroundColor = UIColor.whiteColor()
        theme02.backgroundColor = UIColor.whiteColor()

        collections  += [theme01.screenshotImage(scale: 2.0)]
        collections  += [theme02.screenshotImage(scale: 2.0)]
        
        samsara.images = collections
        samsara.delegate = self
        samsara.currentIndex = 0
        samsara.reload()
        
        
        
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgeSwipe:")
        edgePanGestureRecognizer.edges = .Left
        samsara.addGestureRecognizer(edgePanGestureRecognizer)
//        interactivePopGestureRecognizer.requireGestureRecognizerToFail(edgePanGestureRecognizer)
        self.edgePanGestureRecognizer = edgePanGestureRecognizer
//        samsara.backgroundColor = UIColor.blackColor()
//        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
//            self.samsara.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7)
//            }) { (finished) in
//                
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

extension ShareController : UIImageSamsaraViewDelegate{
    func didSelectIndex(index: Int) {
        
        println("INdex : \(index)")
//        if let viewControllers = self.viewControllers as? [UIViewController] {
//            var destinationViewController: UIViewController?
//            for (currentIndex, viewController) in enumerate(viewControllers) {
//                if currentIndex == index {
//                    destinationViewController = viewController
//                    break
//                }
//            }
//            
//            if let viewController = destinationViewController {
//                popToViewController(viewController, animated: false)
//            }
//            
//            
//            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
//                self.historyViewController.view.transform = CGAffineTransformIdentity
//                self.historyViewController.scrollToIndex(index, animated: false)
//                }) { (finished) in
//                    self.coverView.hidden = true
//                    self.historyContentView.hidden = true
//                    self.historyViewController.view.alpha = 0.0
//                    self.setNavigationBarHidden(false, animated: false)
//            }
//        }
    }
    
    
    func handleEdgeSwipe(gesture: UIScreenEdgePanGestureRecognizer) {
        
        if collections.count > 0 {
            var progress = gesture.translationInView(view).x / view.bounds.size.width
            progress = min(1.0, max(0.0, progress))
            
            switch gesture.state {
            case .Began:
                edgeSwiping = true
//                popViewControllerAnimated(true)
                
            case .Changed:
                defaultInteractiveTransition.updateInteractiveTransition(progress)
                
            case .Ended, .Cancelled:
                if progress > 0.5 {
                    collections.removeLast()
                    defaultInteractiveTransition.finishInteractiveTransition()
                } else {
                    defaultInteractiveTransition.cancelInteractiveTransition()
                }
                edgeSwiping = false
                
//                if let animationController = animationController as? SAHistoryNavigationTransitionController {
//                    animationController.forceFinish()
//                }
                animationController = nil
                
            case .Failed, .Possible:
                break
            }
        }
    }
}


extension ShareController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
//        if let backItem = visibleViewController.navigationController?.navigationBar.backItem {
//            var height = 64.0
//            if visibleViewController.navigationController?.navigationBarHidden == true {
//                height = 44.0
//            }
//            let backButtonFrame = CGRect(x: 0.0, y :0.0,  width: 100.0, height: height)
//            let touchPoint = gestureRecognizer.locationInView(gestureRecognizer.view)
//            if CGRectContainsPoint(backButtonFrame, touchPoint) {
//                return true
//            }
//        }
        
        if let gestureRecognizer = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
            if view == gestureRecognizer.view {
                return true
            }
        }
        
        return false
    }
}