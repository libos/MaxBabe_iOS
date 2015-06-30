//
//  City.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation
import CoreLocation

class City: NSObject,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate {
    var city_name_p:String?
    var city_name:String? {
        get{
            return city_name_p
        }
        set (new_name){
            city_name_p = new_name
        }
    }
    
    var city_code:String?
    var level2:String?
    var province:String?
    var country:String?
    var district:String?
    let center = Center.getInstance
    var isFirstUpdate:Bool
    let locationManager:CLLocationManager = CLLocationManager()
    let searcher:BMKGeoCodeSearch
    static let stopwords:[String] = ["市","市辖区","自治区", "自治州", "地区", "特别行政区"]
    var state:Int = 0
 
    class var getInstance:City {
        struct Singleton {
            static let instance = City()
        }

        return Singleton.instance
    }
    
    override init(){
        isFirstUpdate = false
        searcher = BMKGeoCodeSearch()
        super.init()
        locationManager.delegate = self
        searcher.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        
        if center.ios8() {
            locationManager.requestAlwaysAuthorization()
        }
        
        if self.city_name == nil {
            loadFromDefaults()
            if self.city_name == nil {
                self.updateLoction()
            }
        }

    }
    
    init(city_name:String,city_code:String,level2:String,province:String,country:String){
        self.city_code = city_code
        self.level2 = level2
        self.province = province
        self.country = country
         searcher = BMKGeoCodeSearch()
        isFirstUpdate = false
        super.init()
        self.city_name = city_name
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        if center.ios8() {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
    }
    func loadFromDefaults(){
        let st = NSUserDefaults.standardUserDefaults()
        self.province = st.valueForKey(Global.cityProvince) as? String
        self.district = st.valueForKey(Global.cityDistrict) as? String
        if let x = st.valueForKey(Global.cityCityName) as? String {
            self.setCityName(x)
        }
    }
    
    func updateLoction(){
        self.isFirstUpdate = false
        locationManager.startUpdatingLocation()
    }
    
    func cleanCityName() -> String?{
        if (self.city_name == nil) {
            return nil
        }
        var ret_name:String = self.city_name!
        for wd in City.stopwords {
            ret_name = ret_name.stringByReplacingOccurrencesOfString(wd, withString: "")
        }
        return ret_name
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        if (self.isFirstUpdate) {
            return
        }
        self.locationManager.stopUpdatingLocation();
        self.isFirstUpdate = true
        var location:CLLocation = locations.last as! CLLocation

        if location.horizontalAccuracy > 0 {
//            println( "\(location.coordinate.latitude)")
//            println( "\(location.coordinate.longitude)")
            var pt:CLLocationCoordinate2D = location.coordinate
            var reverseGeoCodeSearchOption:BMKReverseGeoCodeOption = BMKReverseGeoCodeOption.alloc()
            reverseGeoCodeSearchOption.reverseGeoPoint = pt
            var flag:Bool = searcher.reverseGeoCode(reverseGeoCodeSearchOption)

            if(!flag)
            {
              println("反geo检索发送失败");
            }
        }
    }

    func setCityName(name:String){
        if (name != ""){
            self.willChangeValueForKey("city_name")
            self.city_name = name
            self.didChangeValueForKey("city_name")
            save_city()
        }
    }
    
    
    func save_city(){
        
        let st = NSUserDefaults.standardUserDefaults()
        st.setValue(self.city_name, forKey: Global.cityCityName)
        st.setValue(self.district, forKey: Global.cityDistrict)
        st.setValue(self.province, forKey: Global.cityProvince)
        st.synchronize()
        var stGroup = NSUserDefaults(suiteName: "group.maxtain.MaxBabe")
        stGroup!.setValue(self.city_name, forKey: Global.cityCityName)
        stGroup!.setValue(center.s2t(self.city_name)!, forKey: Global.cityCityDisplayName)
        stGroup!.setValue(center.s2t(self.district)!, forKey: Global.cityDistrict)
        stGroup!.setValue(self.province, forKey: Global.cityProvince)
        stGroup!.setBool(true, forKey: Global.widget_first_start_app)
        stGroup!.synchronize()
    }

    func onGetReverseGeoCodeResult(searcher:BMKGeoCodeSearch,result:BMKReverseGeoCodeResult,errorCode error:BMKSearchErrorCode){
        if error.value == 0 {
            let addr = result.addressDetail
            self.district = addr.district
            self.province = addr.province
            setCityName(addr.city)
          }else {
            println("抱歉，未找到结果")
          }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println(error)
    }

}


extension City{

    static func selectDatabase(filter:String) -> [String]{
        let database:FMDatabase =  Center.getInstance.database!
        // filter
        var part:String = filter.stringByReplacingOccurrencesOfString("'", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")

        var xfilter = "( name like '\(part)%' ) or ( pinyin like '\(part)%' ) or ( level2 like '\(part)%' ) or ( province like '\(part)%' ) or ( '\(part)' like '%' || name || '%' ) or ( '\(part)' like '%' || pinyin || '%' ) limit 8"
        
        // search
        var list:[String] = []
        if let rs = database.executeQuery("select name,level2,province from city where \(xfilter)", withArgumentsInArray: nil) {
            while rs.next() {
                let name = rs.stringForColumn("name")
                let level2 = rs.stringForColumn("level2")
                let province = rs.stringForColumn("province")
                list.append("\(name):\(level2):\(province)")

            }
        } else {
            println("select failed: \(database.lastErrorMessage())")
        }
        return list
    }

}