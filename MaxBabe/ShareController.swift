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
    
    @IBOutlet weak var SharePanel: UIView!
    @IBOutlet weak var SharePanelBottom: NSLayoutConstraint!
    
//    @IBOutlet weak var hotSpot: UIButton!
    @IBOutlet weak var shareTitle: UILabel!
    
    var collections = [UIImage]()
    var themeManger:[UIShareTheme] = []
//    var hotSpotBtn = UIButton()
    var themeSpotArr = [CGRect]()
    private let defaultInteractiveTransition = UIPercentDrivenInteractiveTransition()
    private var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private var animationController: UIViewControllerAnimatedTransitioning?
    private var edgeSwiping = false
    
    var tapImageRecognizer:UITapGestureRecognizer?
    var swipeDownReco:UISwipeGestureRecognizer?
    var swipeUpReco:UISwipeGestureRecognizer?
    var the_word:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let size = UIScreen.mainScreen().bounds.size
//        let item_size = CGSize(width: size.width * Global.SHARE_CARD_WIDTH_RATION, height: size.height * Global.SHARE_CARD_HEIGHT_RATION)
        let st = NSUserDefaults.standardUserDefaults()
        self.the_word = Center.getInstance.s2t(st.stringForKey(Global.THE_WORD)!)

        addTheme(self.the_word)
        
//        for theme in themeManger {
//            var cs = theme.uiWord!.convertRect(theme.uiWord!.bounds, toView: theme)
//            var t_rect = CGRectMake(cs.origin.x + samsara.ls_inset - 5, cs.origin.y, cs.size.width, cs.size.height)
//            themeSpotArr.append(t_rect)
//        }
        
//        var cs = theme01.uiWord!.convertRect(theme01.uiWord!.bounds, toView: theme01)
//        var t01_rect = CGRectMake(cs.origin.x + samsara.ls_inset - 5, cs.origin.y, cs.size.width, cs.size.height)
//        cs = theme02.uiWord!.convertRect(theme01.uiWord!.bounds, toView: theme02)
//        var t02_rect = CGRectMake(cs.origin.x + samsara.ls_inset - 5, cs.origin.y, cs.size.width, cs.size.height)
//        themeSpotArr.append(t01_rect)
//        themeSpotArr.append(t02_rect)
//        hotSpotBtn.backgroundColor = UIColor(white: 0, alpha: 0.5)
//        
//        hotSpotBtn.frame = themeSpotArr[samsara.currentIndex]
//        hotSpotBtn.addTarget(self, action: "hotSpot:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.samsara.addSubview(hotSpotBtn)
       
        samsara.images = collections
        samsara.delegate = self
        samsara.currentIndex = 0
        samsara.reload()
//        samsara.loginBtn.addTarget(self, action: "logIn:", forControlEvents: UIControlEvents.TouchUpInside)

        tapImageRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopUp:")
        tapImageRecognizer?.numberOfTapsRequired = 1
        tapImageRecognizer?.numberOfTouchesRequired = 1
        tapImageRecognizer?.cancelsTouchesInView = false
        tapImageRecognizer?.delegate = self
        self.shareTitle.addGestureRecognizer(tapImageRecognizer!)
        self.samsara.addGestureRecognizer(tapImageRecognizer!)
        self.view.addGestureRecognizer(tapImageRecognizer!)

        swipeDownReco = UISwipeGestureRecognizer(target: self, action: "dismissPopUp:")
        swipeDownReco?.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDownReco!)
        
        swipeUpReco = UISwipeGestureRecognizer(target: self, action: "shareAction:")
        swipeUpReco?.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUpReco!)
        
        
        self.samsara.addObserver(self, forKeyPath: "currentIndex", options: NSKeyValueObservingOptions.New, context: nil)

        
        self.view.userInteractionEnabled = true
        self.view.exclusiveTouch = true
//        self.SharePanel.userInteractionEnabled = false
    }
    func addTheme(word:String?){
//        for th in themeManger {
//            th.removeFromSuperview()
//        }
//        for idx in 0..<collections.count {
//            collections[idx] = nil
//        }
        
//        collections.removeAll(keepCapacity: true)
        collections = []
        themeManger = []
        var theme01 = UIShareTheme(xml: getTheme("theme01"),the_word:word)
        var theme02 = UIShareTheme(xml: getTheme("theme02"),the_word:word)
        var theme03 = UIShareTheme(xml: getTheme("theme03"),the_word:word)
        var theme04 = UIShareTheme(xml: getTheme("theme04"),the_word:word)
 
//        collections  += [theme01.screenshotImage(scale: 3.0)]
//        collections  += [theme02.screenshotImage(scale: 3.0)]
//        collections  += [theme03.screenshotImage(scale: 3.0)]
//        collections  += [theme04.screenshotImage(scale: 3.0)]

        var im1 = theme01.screenshotImage(scale: 2.0)
        var im2 = theme02.screenshotImage(scale: 2.0)
        var im3 = theme03.screenshotImage(scale: 2.0)
        var im4 = theme04.screenshotImage(scale: 2.0)
        collections  += [im1.memory]
        collections  += [im2.memory]
        collections  += [im3.memory]
        collections  += [im4.memory]
        
        im1.destroy()
        im2.destroy()
        im3.destroy()
        im4.destroy()
        im1.dealloc(1)
        im2.dealloc(1)
        im3.dealloc(1)
        im4.dealloc(1)
//        theme01.removeAllSubviews()
//        theme02.removeAllSubviews()
//        theme03.removeAllSubviews()
//        theme04.removeAllSubviews()
//        theme01.removeFromSuperview()
//        theme02.removeFromSuperview()
//        theme03.removeFromSuperview()
//        theme04.removeFromSuperview()
//        themeManger.append(theme01)
//        themeManger.append(theme02)
//        themeManger.append(theme03)
//        themeManger.append(theme04)
    }
    
    deinit{
        collections.removeAll(keepCapacity: false)
//        for th in themeManger {
//            th.removeFromSuperview()
//        }
        self.samsara.removeObserver(self, forKeyPath: "currentIndex")
    }
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        hotSpotBtn.frame = themeSpotArr[samsara.currentIndex]
    }
    
    func getTheme(name:String)->String{
        return String(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: "xml")!, encoding: NSUTF8StringEncoding, error: nil)!
    }

    
    @IBAction func hotSpot(sender:UIButton)
    {
        self.performSegueWithIdentifier("toShareEdit", sender: sender)
    }
    func logIn(sender:UIButton){
        self.performSegueWithIdentifier("toLoginChooseSegue", sender: sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShareEdit"
        {
            var se = segue.destinationViewController as! ShareEditController
            se.preText = self.the_word
        }
    }
    
    @IBAction func unwindSegueFromShareEdit(segue : UIStoryboardSegue){
        if segue.identifier == "backToShare" {
            var svc:ShareEditController = segue.sourceViewController as! ShareEditController
            self.the_word = svc.ret_str
            addTheme(self.the_word)

            samsara.images = collections
            
            samsara.reload()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        println("whiwhwiw")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.SharePanel.hidden = false
        SharePanelBottom.constant = -SharePanel.bounds.height
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        if !Center.getInstance.isLogin() && samsara.getCurrentIndex() > 0 {
            self.logIn(sender as! UIButton)
            return
        }
        self.SharePanelBottom.constant = 0
        self.SharePanel.needsUpdateConstraints()
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.SharePanel.layoutIfNeeded()
            }) { (finished:Bool) -> Void in
                
        }
    }
    
    func dismissPopUp(gesture:UIGestureRecognizer){
       self.SharePanelBottom.constant = -self.SharePanel.bounds.height
        self.SharePanel.needsUpdateConstraints()

        UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.SharePanel.layoutIfNeeded()
            }) { (finished:Bool) -> Void in
                // finished
        }
    }
    
}



extension ShareController : UIImageSamsaraViewDelegate{
    func didSelectIndex(index: Int) {
//        println("INdex : \(index)")
    }
    
    func performSegue(name: String,sender:UIButton) {
        self.performSegueWithIdentifier(name, sender: sender)
    }
    
    @IBAction func loggedBackUnwindSegue(segue:UIStoryboardSegue){
        
        samsara.reload()
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        println("hhh")
        return true
    }
    @IBAction func LogoutUnwindSegue(segue:UIStoryboardSegue){
        //var source:UIViewController = segue.sourceViewController as! UIViewController
        
        samsara.reload()
        
    }
}
extension ShareController{
    
    @IBAction func wechatCircle(sender: AnyObject) {
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeImage
        // ===> UMShareToWechatTimeline
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatTimeline], content: "", image: (collections[samsara.getCurrentIndex()]), location:nil, urlResource: nil, presentedController: self) { (response:UMSocialResponseEntity!) -> Void in
            if (response.responseCode.value == UMSResponseCodeSuccess.value) {
                println("Circle分享成功！")
            }
        }
//        "wx1d3399ae82a092e5"
    }
    
    @IBAction func wechat(sender: AnyObject) {
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeImage
        // ===> UMShareToWechatSession
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatSession], content: "", image: (collections[samsara.getCurrentIndex()]), location:nil, urlResource: nil, presentedController: self) { (response:UMSocialResponseEntity!) -> Void in
            if (response.responseCode.value == UMSResponseCodeSuccess.value) {
                println("Wechat分享成功！")
            }
        }
    }
    
    
    @IBAction func weibo(sender: AnyObject) {
        UMSocialControllerService.defaultControllerService().setShareText("", shareImage: (collections[samsara.getCurrentIndex()]), socialUIDelegate: self)

        UMSocialDataService.defaultDataService().requestAddFollow(UMShareToSina, followedUsid: ["1401240637"], completion: nil)
        
        UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToSina).snsClickHandler(self,UMSocialControllerService.defaultControllerService(),true)
    }
    
    @IBAction func qq(sender: AnyObject) {
        UMSocialData.defaultData().extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage
        
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToQQ], content: "", image: (collections[samsara.getCurrentIndex()]), location:nil, urlResource: nil, presentedController: self) { (response:UMSocialResponseEntity!) -> Void in
            if (response.responseCode.value == UMSResponseCodeSuccess.value) {
                println("QQ分享成功！")
            }
        }
    }
    
    
    @IBAction func instagram(sender: AnyObject) {
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToInstagram], content: "", image: (collections[samsara.getCurrentIndex()]), location:nil, urlResource: nil, presentedController: self) { (response:UMSocialResponseEntity!) -> Void in
            if (response.responseCode.value == UMSResponseCodeSuccess.value) {
                println("Instagram分享成功！")
            }
        }

    }
    @IBAction func facebook(sender: AnyObject) {
        UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToFacebook], content: "", image: (collections[samsara.getCurrentIndex()]), location:nil, urlResource: nil, presentedController: self) { (response:UMSocialResponseEntity!) -> Void in
            if (response.responseCode.value == UMSResponseCodeSuccess.value) {
                println("Facebook分享成功！")
            }
        }

    }
    
}
extension ShareController:UIGestureRecognizerDelegate{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view == SharePanel || touch.view.superview == SharePanel{
            return false
        }else{
            return true
        }
    }
}
extension ShareController:UMSocialUIDelegate{
    
}