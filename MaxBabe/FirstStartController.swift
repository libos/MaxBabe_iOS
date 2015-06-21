//
//  FirstStartController.swift
//  MaxBabe
//
//  Created by Liber on 6/19/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//
import UIKit

class FirstStartController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var mBackground: UIImageView!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mContent: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
 
    let screen_size = UIScreen.mainScreen().bounds.size
    
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    var page1:UIView!
    var page2:UIView!
    var page3:UIView!
    var pageControlBeingUsed:Bool = false
    var performJump:Bool = false
    
    @IBOutlet weak var ivGuide01: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = 3

        scrollView.contentSize = CGSizeMake(screen_size.width*3, screen_size.height)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        page1 = UIView(frame: CGRectMake(0, 0, screen_size.width, screen_size.height))
        page2 = UIView(frame: CGRectMake(screen_size.width, 0, screen_size.width, screen_size.height))
        page3 = UIView(frame: CGRectMake(2*screen_size.width, 0, screen_size.width, screen_size.height))
//        v1.backgroundColor = UIColor.blackColor()
//        v2.backgroundColor = UIColor.blueColor()
//        v3.backgroundColor = UIColor.redColor()
        
        v1.setTranslatesAutoresizingMaskIntoConstraints(false)
        v2.setTranslatesAutoresizingMaskIntoConstraints(false)
        v3.setTranslatesAutoresizingMaskIntoConstraints(false)
        page1.addSubview(v1)
        page2.addSubview(v2)
        page3.addSubview(v3)
        
        page1.addConstraint(NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: page1, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        page1.addConstraint(NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: page1, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        page1.addConstraint(NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: page1, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        page1.addConstraint(NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: page1, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        page2.addConstraint(NSLayoutConstraint(item: v2, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: page2, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        page2.addConstraint(NSLayoutConstraint(item: v2, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: page2, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        page2.addConstraint(NSLayoutConstraint(item: v2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: page2, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        page2.addConstraint(NSLayoutConstraint(item: v2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: page2, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        page3.addConstraint(NSLayoutConstraint(item: v3, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: page3, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        page3.addConstraint(NSLayoutConstraint(item: v3, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: page3, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        page3.addConstraint(NSLayoutConstraint(item: v3, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: page3, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        page3.addConstraint(NSLayoutConstraint(item: v3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: page3, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))

        scrollView.addSubview(page1)
        scrollView.addSubview(page2)
        scrollView.addSubview(page3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changePage(sender: AnyObject) {
        var frame:CGRect = CGRect()
        frame.origin.x = self.scrollView.frame.size.width * CGFloat(self.pageControl.currentPage)
        frame.origin.y = 0
        frame.size = self.scrollView.frame.size
        self.scrollView.scrollRectToVisible(frame, animated: true)
        pageControlBeingUsed = true

    }
    
    @IBAction func nexPage(sender: AnyObject) {
        if self.pageControl.currentPage == 2 {
            let st = NSUserDefaults.standardUserDefaults()
            st.setBool(true, forKey: Global.isFirstStart)
            st.setValue(NSBundle.mainBundle().pathForResource("daytime_clear01", ofType: "png"), forKey: Global.THE_BACKGROUND)
            st.setValue(NSBundle.mainBundle().pathForResource("f_normal01", ofType: "png"), forKey: Global.THE_FIGURE)
            st.setValue("今天天气不错", forKey: Global.THE_WORD)
            st.synchronize()
            self.performSegueWithIdentifier("showFromFirstStart", sender: self)
            return
        }
        if self.pageControl.currentPage == 1{
            self.scrollView.backgroundColor = UIColor(rgba: "#D46E64")
            continueBtn.setTitle("开启", forState: UIControlState.Normal)
            performJump = true
        }


        self.pageControl.currentPage += 1
        changePage(sender)
        
    }
    
    @IBAction func jumpToApp(sender: AnyObject) {
        self.performSegueWithIdentifier("showFromFirstStart", sender: self)
    }

}

extension FirstStartController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !pageControlBeingUsed {
            var pageWidth:CGFloat = self.scrollView.frame.size.width;
            var page:Int = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
            self.pageControl.currentPage = page
            if page > 1{
                self.scrollView.backgroundColor = UIColor(rgba: "#D46E64")
                continueBtn.setTitle("开启", forState: UIControlState.Normal)
                performJump = true
            }else{
                self.scrollView.backgroundColor = UIColor(rgba: "#836DB2")
                continueBtn.setTitle("继续", forState: UIControlState.Normal)
                performJump = false
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControlBeingUsed = false

    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pageControlBeingUsed = false
    }
 
}

