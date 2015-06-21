//
//  ShareEditController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class ShareEditController: UIViewController {

    var preText:String?
    
    @IBOutlet weak var editModeField: UITextView!
  
    var wordsList = [String]()
    @IBOutlet weak var wordsTable: UITableView!
    var lastSelected:UIButton? = nil
    
    @IBOutlet weak var editPanel: UIView!
    @IBOutlet weak var listPanel: UIView!
    @IBOutlet weak var lbLeftNumber: UILabel!
    
    @IBOutlet weak var editPanelCenterX: NSLayoutConstraint!
    @IBOutlet weak var listPanelCenterX: NSLayoutConstraint!
    
    let screen_size = UIScreen.mainScreen().bounds.size

    var currentState:Int = 0
    var list_choosed:String? = nil
    var ret_str:String? = nil

    @IBOutlet weak var btnToList: UIButton!
    @IBOutlet weak var btnToEdit: UIButton!
    
    
    @IBOutlet weak var barLine: UIView!
    @IBOutlet weak var barLineCenterX: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editModeField.contentInset = UIEdgeInsetsMake(10, 10, 10, -10)
        
        ret_str = preText!
        
        var oRange = NSMakeRange(0, count(preText!))
        var strPre = NSMutableAttributedString(string: preText!)
        strPre.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        strPre.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: oRange)
        var linestyle = NSMutableParagraphStyle()
        linestyle.lineHeightMultiple = 1.5
        linestyle.alignment = NSTextAlignment.Left
        strPre.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)

        editModeField.attributedText = strPre
        
        var len = 45 - count(editModeField.text)
        lbLeftNumber.text = "还可输入 \(len) 字"
        
        
        wordsList = Oneword.getShareEdit()
        
        wordsTable.backgroundColor = UIColor.clearColor()
        wordsTable.separatorColor = UIColor.clearColor()
        wordsTable.separatorInset = UIEdgeInsetsZero
        wordsTable.delegate = self
        wordsTable.dataSource = self
        wordsTable.autoresizesSubviews = true
        
        editPanel.hidden = false
        listPanel.hidden = true
        editModeField.becomeFirstResponder()
        editModeField.delegate = self
        editPanelCenterX.constant = 0
        listPanelCenterX.constant = -screen_size.width
        
        
        var swipeGestureLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeFrom:")
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeGestureLeft)

        var swipeGestureRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeFrom:")
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeGestureRight)
        
        
    }

    func handleSwipeFrom(sender:UISwipeGestureRecognizer){
        if sender.direction == UISwipeGestureRecognizerDirection.Left {
            listClicked(sender)
        }else if sender.direction == UISwipeGestureRecognizerDirection.Right {
            editClicked(sender)
        }
    }
    
    @IBAction func editClicked(sender: AnyObject) {
        if currentState == 1 {
            self.editPanelCenterX.constant = 0
            self.listPanelCenterX.constant = -self.screen_size.width
            self.barLineCenterX.constant = 0
            editPanel.needsUpdateConstraints()
            listPanel.needsUpdateConstraints()
            barLine.needsUpdateConstraints()
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.editPanel.layoutIfNeeded()
                self.listPanel.layoutIfNeeded()
                self.barLine.layoutIfNeeded()
                }, completion: { (finished:Bool) -> Void in
                    if finished {
                        self.currentState = 0
                        self.editModeField.becomeFirstResponder()
                    }
            })
        }else{
            
        }

    }
    
    @IBAction func listClicked(sender: AnyObject) {
        if currentState == 0 {
            // dispear keyboard
            listPanel.hidden = false
            self.editModeField.resignFirstResponder()
            self.editPanelCenterX.constant = self.screen_size.width
            self.listPanelCenterX.constant = 0
            self.barLineCenterX.constant = btnToList.frame.origin.x - btnToEdit.frame.origin.x
            editPanel.needsUpdateConstraints()
            listPanel.needsUpdateConstraints()
            barLine.needsUpdateConstraints()
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.editPanel.layoutIfNeeded()
                self.listPanel.layoutIfNeeded()
                self.barLine.layoutIfNeeded()
                }, completion: { (finished:Bool) -> Void in
                    if finished{
                        self.currentState = 1
                    }
            })
        }else{
            
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.beginLogPageView(toString(self.dynamicType))
    }

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToShare"{
            if currentState == 0 {
                if editModeField.text.trim() != "" {
                    ret_str = editModeField.text
                }else if list_choosed != nil{
                    ret_str = list_choosed
                }
            }else{
                if list_choosed != nil{
                    ret_str = list_choosed
                }else if editModeField.text.trim() != "" {
                    ret_str = editModeField.text
                }
            }
        }
    }
}


extension ShareEditController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return wordsList.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCellWithIdentifier("mood_reuse") as? UITableViewCell
        
        var button:UIButton? =  cell?.viewWithTag(1) as? UIButton
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.separatorInset = UIEdgeInsetsZero
        cell?.textLabel?.hidden = true
        
        var oRange = NSMakeRange(0, count(self.wordsList[indexPath.section]))
        var strPre = NSMutableAttributedString(string: self.wordsList[indexPath.section])
        strPre.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        strPre.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: oRange)
        var linestyle = NSMutableParagraphStyle()
        linestyle.lineHeightMultiple = 1.2
        linestyle.alignment = NSTextAlignment.Left
        strPre.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
        
        button?.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        button?.titleLabel?.numberOfLines = 2
        button?.titleLabel?.adjustsFontSizeToFitWidth = true
        button?.titleLabel?.minimumScaleFactor = 0.6

        button?.setAttributedTitle(strPre, forState: UIControlState.Normal)
        button?.addTarget(self, action: "onClickCell:", forControlEvents: UIControlEvents.TouchUpInside)
//        button?.backgroundColor = UIColor.blackColor()
        button?.sizeToFit()
        cell?.sizeToFit()

        
        return cell!
    }
    
    func onClickCell(sender:UIButton){
        var str = sender.attributedTitleForState(UIControlState.Normal)!.string
        var oRange = NSMakeRange(0, count(str))
        var strPre = NSMutableAttributedString(string:str)
        strPre.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: oRange)
        strPre.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: oRange)
        var linestyle = NSMutableParagraphStyle()
        linestyle.lineHeightMultiple = 1.2
        linestyle.alignment = NSTextAlignment.Left
        strPre.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
        
        sender.setAttributedTitle(strPre, forState: UIControlState.Normal)
        sender.backgroundColor = UIColor(white: 255, alpha: 0.6)
        
        list_choosed = str
        
        
        if lastSelected != nil {
            str = lastSelected!.attributedTitleForState(UIControlState.Normal)!.string
            oRange = NSMakeRange(0, count(str))
            strPre = NSMutableAttributedString(string:str)
            strPre.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
            strPre.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: oRange)
            var linestyle = NSMutableParagraphStyle()
            linestyle.lineHeightMultiple = 1.2
            linestyle.alignment = NSTextAlignment.Left
            strPre.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
            lastSelected!.setAttributedTitle(strPre, forState: UIControlState.Normal)
            lastSelected!.backgroundColor = UIColor(white: 255, alpha: 0.18)
        }
      
        
        lastSelected = sender
    }
}

extension ShareEditController:UITextViewDelegate{
    func textViewDidChange(textView: UITextView){
        println(textView.text)
        var len = 45 - count(textView.text)
        if len <= 0 {
            len = 0
        }
        lbLeftNumber.text = "还可输入 \(len) 字"
    }
}

