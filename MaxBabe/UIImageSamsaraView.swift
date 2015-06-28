//
//  ImageSwitcher.swift
//  MaxBabe
//
//  Created by Liber on 6/13/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//


import UIKit

protocol UIImageSamsaraViewDelegate: class {
    func didSelectIndex(index: Int)
    func performSegue(name:String,sender:UIButton)
}


class UIImageSamsaraView: UIView {
    
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var images: [UIImage]?
    var _currentIndex:Int = 0
    
    var currentIndex: Int {
        get{
            return _currentIndex
        }
        set {
            _currentIndex = newValue
        }
    }
 
    
    weak var delegate: UIImageSamsaraViewDelegate?
    
    private var kLineSpace: CGFloat = 20.0
   
    let screen_size = UIScreen.mainScreen().bounds.size
    var ls_inset:CGFloat
    var item_size:CGSize
    required init(coder aDecoder: NSCoder) {

        item_size = CGSize(width: screen_size.width * Global.SHARE_CARD_WIDTH_RATION, height: screen_size.height * Global.SHARE_CARD_HEIGHT_RATION - 36)
        ls_inset = CGFloat(screen_size.width - item_size.width) / 2.0

        super.init(coder: aDecoder)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.backgroundColor = UIColor.clearColor()
        let right_inset:CGFloat = 20.0
        //        kLineSpace = inset

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {

            layout.itemSize = item_size
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = 20.0
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: ls_inset, bottom: 0.0, right: ls_inset)
            layout.scrollDirection = .Horizontal
        }
        self.clipsToBounds = false
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clearColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = false
        collectionView.clipsToBounds = false
//
//        self.addSubview(collectionView)
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        NSLayoutConstraint.applyAutoLayout(self, target: collectionView, index: nil, top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, height: nil, width: nil)
    }

    deinit{
        images?.removeAll(keepCapacity: true)
        collectionView.removeAllSubviews()
        collectionView.removeFromSuperview()
    }
    func reload() {
        collectionView.reloadData()
        scrollToIndex(currentIndex, animated: false)
    }
    
    func scrollToIndex(index: Int, animated: Bool) {
        let width = item_size.width//UIScreen.mainScreen().bounds.size.width
        collectionView.setContentOffset(CGPoint(x: (width + kLineSpace) * CGFloat(index), y: 0), animated: animated)
    }
    func getCurrentIndex()->Int{
        return currentIndex
    }

    func setCurrentIndex(){
        var rawPageValue:CGFloat = self.collectionView.contentOffset.x / CGFloat(self.item_size.width + 20.0)
        var currentPage:CGFloat =  ceil(rawPageValue)
        if currentPage >= CGFloat(images!.count) {
            currentPage = CGFloat(images!.count) - 1
        }else if currentPage < 0 {
            currentPage = 0
        }
        println("currentIndex:\(currentPage)")
        self.willChangeValueForKey("currentIndex")
        self.currentIndex = Int(currentPage)
        self.didChangeValueForKey("currentIndex")
        
    }
}

extension UIImageSamsaraView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = images?.count {
            return count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        for view in cell.subviews {
            if let view = view as? UIImageView {
                view.removeFromSuperview()
            }
            if let view = view as? UIButton {
                view.removeFromSuperview()
            }
        }
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.image = images?[indexPath.row]
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowRadius = 4.0
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSizeMake(0, 0)
        cell.addSubview(imageView)
        if indexPath.row > 0 && !Center.getInstance.isLogin(){
            
            
//            var ivLock = UIImageView(image: UIImage(named: "icon_locked"))
//            ivLock.setTranslatesAutoresizingMaskIntoConstraints(false)

//            var loginView = UIView(frame: CGRectMake(0, 0, cell.bounds.width, 30))
//            loginView.backgroundColor = UIColor(white: 0, alpha: 0.6)
//            
            var loginBtn = UIButton()
            loginBtn.setBackgroundImage(UIImage(named: "floattip_bg")!, forState: UIControlState.Normal)
            loginBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 5, -10)
            loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            loginBtn.setTitle(Center.getInstance.s2t("模板登录后可用")!, forState: UIControlState.Normal)
            loginBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
            loginBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
            loginBtn.addTarget(self, action: "loginIn:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(loginBtn)
            cell.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 108))
            cell.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 38))
            cell.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 12))
            cell.addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            self.bringSubviewToFront(loginBtn)
        }
   

        return cell
    }
    func loginIn(sender:UIButton){
        delegate?.performSegue("toLoginChooseSegue",sender: sender)
    }
    
}
extension UICollectionViewFlowLayout{
    func pageWidth() -> CGFloat {
        return self.itemSize.width + 20.0
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var rawPageValue:CGFloat = self.collectionView!.contentOffset.x / pageWidth()
        var currentPage:CGFloat = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue)
        var nextPage:CGFloat = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue)
        var pannedLessThanAPage:Bool = fabs(1 + currentPage - rawPageValue) > 0.5
        var flicked:Bool = fabs(velocity.x) > 0.3
        var proposedContentOffset:CGPoint = CGPoint()
        if pannedLessThanAPage && flicked {
            proposedContentOffset.x = nextPage*self.pageWidth()
        }else{
            proposedContentOffset.x = round(rawPageValue) * self.pageWidth()
        }
        return proposedContentOffset
    }
}

extension UIImageSamsaraView: UICollectionViewDelegate {//
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        delegate?.didSelectIndex(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        println("hello\(indexPath.row)" )
        setCurrentIndex()
    }
}

extension UIImageSamsaraView:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        setCurrentIndex()
        println("scrollViewDidEndDecelerating")
    }
}

