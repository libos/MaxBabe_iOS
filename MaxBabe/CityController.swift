//
//  CityController.swift
//  MaxBabe
//
//  Created by Liber on 5/27/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

import UIKit

class CityController: UIViewController,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate  {

    let center = Center.getInstance
    let city = City.getInstance
    var delegate:PassValueDelegate?
    var located:Bool = false
    var city_name:String?
    var province:String?
    var district:String?
    var listData:[String] = []
    var isDefaultData:Bool = true
    @IBOutlet weak var cityList: UITableView!
    @IBOutlet weak var cityLocatedName: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchDisplay: UISearchDisplayController!
    @IBOutlet weak var autoLocationView: UIView!
    @IBOutlet weak var verticalSpaceTo: NSLayoutConstraint!

    @IBOutlet weak var lbHotCity: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    let locationManager:CLLocationManager = CLLocationManager()
    let searcher:BMKGeoCodeSearch = BMKGeoCodeSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if center.isTwChinese(){
            listData = Global.DefaultTWCityList
        }else{
            listData = Global.DefaultCityList
        }
        locationManager.delegate = self
        searcher.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        
        if NSUserDefaults.standardUserDefaults().boolForKey(Global.SETTING_SWITCH_GPS_LOCATING){
            locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        }
        
        if center.ios8() {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        

        cityList.backgroundColor = UIColor.clearColor()
        cityList.separatorColor = UIColor.clearColor()
        cityList.delegate = self
        cityList.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func chooseLocated(sender: AnyObject) {
        var dict:NSMutableDictionary = NSMutableDictionary()
        dict.setValue("city", forKey: "from")
        if located {
            dict.setValue(center.s2t(cityLocatedName.text!), forKey: "city_display_name")
            city.district = self.district!
            city.province = self.province!
            city.setCityName(self.city_name!)
        }else{
            dict.setValue("", forKey: "city_display_name")
        }
        self.delegate?.setValue(dict)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func closeSelf(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

}

extension CityController {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){

        self.locationManager.stopUpdatingLocation();
        var location:CLLocation = locations.last as! CLLocation
        
        if location.horizontalAccuracy > 0 {
//            println( "\(location.coordinate.latitude)")
//            println( "\(location.coordinate.longitude)")
            var pt:CLLocationCoordinate2D = location.coordinate
            var reverseGeoCodeSearchOption:BMKReverseGeoCodeOption = BMKReverseGeoCodeOption.alloc()
            reverseGeoCodeSearchOption.reverseGeoPoint = pt
            var flag:Bool = searcher.reverseGeoCode(reverseGeoCodeSearchOption)
            
//            if(flag)
//            {
//                println("反geo检索发送成功");
//            }
//            else
//            {
//                println("反geo检索发送失败");
//            }
        }
    }
    
    func onGetReverseGeoCodeResult(searcher:BMKGeoCodeSearch,result:BMKReverseGeoCodeResult,errorCode error:BMKSearchErrorCode){
        if error.value == 0 {
            let addr = result.addressDetail
            self.city_name = addr.city
            self.district = addr.district
            self.province = addr.province
            if self.district != nil && self.district != "" {
                cityLocatedName.text = self.district
            }else if self.city_name != nil {
                cityLocatedName.text = self.city_name
            }
            located = true
        }else {
//            println("抱歉，未找到结果")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println(error)
    }

}

extension CityController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func configureCityCell(cell:UITableViewCell,lb:UILabel,city_name:String?,city_detail:String?){
        if city_name == nil {
            let tmp:[String] = city_detail!.componentsSeparatedByString(":")
            if tmp[0] != "" {
                if tmp[0] == tmp[2]{
                    lb.text = center.s2t(tmp[0])
                }else{
                    lb.text = center.s2t(tmp[0] + " " + tmp[2])
                }
            }else{
                lb.text = center.s2t(tmp[1])
            }

        }else{
            lb.text = center.s2t(city_name!)!
        }
        if city_detail == nil {
            cell.textLabel?.text = "\(city_name!):\(city_name!):\(city_name!)"
        }else{
            cell.textLabel!.text = city_detail!;
        }
        cell.imageView!.image = nil;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
//        if tableView == self.cityList {
            var cell:UITableViewCell?
            if indexPath.row%2 == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier(Global.CellCityReuseIdentifier) as? UITableViewCell
            }else{
                cell = tableView.dequeueReusableCellWithIdentifier(Global.CellCityReuse2Identifier) as? UITableViewCell
            }
            var lb:UILabel? =  cell?.viewWithTag(1) as? UILabel

            
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell?.textLabel?.hidden = true //textColor = UIColor.whiteColor()
        

//            if center.isTwChinese(){
//                if isDefaultData {
//                    configureCityCell(cell!,lb:lb!,city_name: listData[indexPath.row],city_detail: nil)
//                }else{
//                    configureCityCell(cell!,lb:lb!,city_name: nil,city_detail: listData[indexPath.row])
//                }
//            }else{
                if isDefaultData {
                    configureCityCell(cell!,lb:lb!,city_name: listData[indexPath.row],city_detail: nil)
                }else{
                    configureCityCell(cell!,lb:lb!,city_name: nil,city_detail:listData[indexPath.row] )
                }
//            }
            return cell!;
//        }
        
    }
}
extension CityController:UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        var lb = cell?.viewWithTag(1) as? UILabel
        
        
        var dict:NSMutableDictionary = NSMutableDictionary()
        dict.setValue("city", forKey: "from")
        
        let dett:String? = cell?.textLabel?.text
        var detail:[String]! =  dett!.componentsSeparatedByString(":")
        
        city.district = detail[0]
        city.province = detail[2]
        city.setCityName(detail[1])

        if city.district != nil && city.district != "" {
            dict.setValue(center.s2t(city.district!)!, forKey: "city_display_name")
        }else if city.city_name != nil{
            dict.setValue(center.s2t(city.city_name!)!, forKey: "city_display_name")
        }
        
        self.delegate?.setValue(dict)

        self.dismissViewControllerAnimated(true, completion: nil)

    }
}


extension CityController:UISearchBarDelegate,UISearchDisplayDelegate {
    

    @IBAction func doSearch(sender: AnyObject) {
        searchBar.hidden = false
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    
        for md in searchBar.subviews {
            for vw in md.subviews {
                if vw.isKindOfClass(UIButton){
                    var x = vw as? UIButton
                    x?.setTitle("取消", forState: UIControlState.Normal)
                    x?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }
                if vw.isKindOfClass(NSClassFromString("UISearchBarBackground")){
                    vw.removeFromSuperview()

                }
            }
        }
        searchBar.backgroundColor = self.view.backgroundColor
        searchBar.placeholder = center.s2t("输入城市关键词")
        searchBar.becomeFirstResponder()
        autoLocationView.hidden = true
        lbHotCity.hidden = true
        closeBtn.hidden = true

        UIView.animateWithDuration(0.5,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.verticalSpaceTo.constant -= (self.cityList.frame.origin.y - self.searchBar.frame.origin.y - self.searchBar.frame.height)
                self.view.layoutIfNeeded()
            },
            completion:{ (finished:Bool) -> Void in
            
            })
    }
    

    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        return true
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) >= 1 && count(searchText) < 10 {
            listData = City.selectDatabase(searchText.cleanCity())
            isDefaultData = false
        }else{
            if center.isTwChinese(){
                listData = Global.DefaultTWCityList
            }else{
                listData = Global.DefaultCityList
            }
            isDefaultData = true
        }
        self.cityList.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if center.isTwChinese(){
            listData = Global.DefaultTWCityList
        }else{
            listData = Global.DefaultCityList
        }
        isDefaultData = true
        self.cityList.reloadData()
        self.searchBar.hidden = true
        self.searchBar.resignFirstResponder()
        self.searchBar.endEditing(true)
        autoLocationView.hidden = false
        lbHotCity.hidden = false
        closeBtn.hidden = false
        UIView.animateWithDuration(0.5,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.verticalSpaceTo.constant = 20
                self.view.layoutIfNeeded()
            },
            completion:{ (finished:Bool) -> Void in
                
        })
    }
}
