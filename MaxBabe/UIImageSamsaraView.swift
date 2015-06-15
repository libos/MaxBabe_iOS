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
}


class UIImageSamsaraView: UIView {
    
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var images: [UIImage]?
    var currentIndex: Int = 0
    
    weak var delegate: UIImageSamsaraViewDelegate?
    
    private var kLineSpace: CGFloat = 20.0
   
    
    let screen_size = UIScreen.mainScreen().bounds.size
    var ls_inset:CGFloat
    var item_size:CGSize
    required init(coder aDecoder: NSCoder) {

        item_size = CGSize(width: screen_size.width * Global.SHARE_CARD_WIDTH_RATION, height: screen_size.height * Global.SHARE_CARD_HEIGHT_RATION)
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

        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clearColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = false
        
//
//        self.addSubview(collectionView)
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        NSLayoutConstraint.applyAutoLayout(self, target: collectionView, index: nil, top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, height: nil, width: nil)
    }

 
    
    func reload() {
        collectionView.reloadData()
//        collectionView.relo
        scrollToIndex(currentIndex, animated: false)
    }
    
    func scrollToIndex(index: Int, animated: Bool) {
        let width = item_size.width//UIScreen.mainScreen().bounds.size.width
        collectionView.setContentOffset(CGPoint(x: (width + kLineSpace) * CGFloat(index), y: 0), animated: animated)
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
        }
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.image = images?[indexPath.row]
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowRadius = 6.0
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSizeMake(0, 0)
        cell.addSubview(imageView)

        return cell
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

}
