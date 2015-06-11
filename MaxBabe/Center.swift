//
//  Center.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

struct Chosen{
    var id:Int?
    var comment:String?
    var path:String?
    var md5:String?
}
class Center :NSObject{
    let database:FMDatabase!
    let isAlreadyInit : Bool = false
    let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    let converter:NCChineseConverter = NCChineseConverter.sharedInstance()
    let default_lang: AnyObject?  = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages")?.objectAtIndex(0)
    
    class var getInstance:Center {
        struct Singleton {
            static let instance = Center()
        }
        return Singleton.instance
    }
    
    override init() {
        let path = documentsFolder.stringByAppendingPathComponent("com.maxtain.maxbabe.sqlite")
        let storeURL:NSURL  = NSURL.fileURLWithPath(path)!
        if !NSFileManager.defaultManager().fileExistsAtPath(storeURL.path!){
            let preloadURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("com.maxtain.maxbabe", ofType: "sqlite")!)
            
            let err : NSErrorPointer = NSErrorPointer()
            if !NSFileManager.defaultManager().copyItemAtURL(preloadURL!, toURL: storeURL, error: err)
            {
                println("Oops, could copy preloaded data")
            }
        }
        println(storeURL.path!)
        database = FMDatabase(path: storeURL.path)
        if !database.open() {
            println("Unable to open database")
         
        }

        if let rs = database.executeQuery("select * from background", withArgumentsInArray: nil) {
            while rs.next() {
                let x = rs.stringForColumn("filename")
                let y = rs.stringForColumn("path")
                let z = rs.stringForColumn("md5")
//                println("x = \(x); y = \(y); z = \(z)")
            }
        } else {
            println("select failed: \(database.lastErrorMessage())")
        }
        super.init()
    }
    
    func s2t(ori:String) -> String{
        if  isTwChinese(){
            return converter.convert(ori, withDict: NCChineseConverterDictTypezh2TW)
        }else{
            return ori
        }
        
    }
    
    func isTwChinese()->Bool{
        if default_lang!.isEqualToString("zh-Hant") {
            return true
        }else{
            return false
        }
    }
    
    
    
//    
//    bool  LanguageManager::isTaiWanChinese()
//    {
//    // get the current language and country config
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//    NSString *currentLanguage = [languages objectAtIndex:0];
//    
//    if ( [currentLanguage isEqualToString:@"zh-Hant"])
//    {
//    return  true;
//    }
//    else
//    {
//    return  false;
//    }
//    
//    }
    
    
    
    
    
    
    func exist(path : String) ->Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func getPath(filename:String) -> String
    {
        
        let path = documentsFolder.stringByAppendingPathComponent(filename)
        if exist(path) {
            return path
        }

        var isDir = ObjCBool(false)
        if !NSFileManager.defaultManager().fileExistsAtPath(path.stringByDeletingLastPathComponent, isDirectory: &isDir){
            NSFileManager.defaultManager().createDirectoryAtPath(path.stringByDeletingLastPathComponent, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        
        return path
        
//        [[NSFileManager defaultManager createDirectoryAtPath:[storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
//            
//            NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)]
    }
    
    func init_db(){
        if !database.executeUpdate(Global.create_background_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        if !database.executeUpdate(Global.create_figure_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        if !database.executeUpdate(Global.create_oneword_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        if !database.executeUpdate(Global.create_city_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        
    }
    
    
    func insert_into()
    {
        //        if !database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", withArgumentsInArray: ["a", "b", "c"]) {
        //            println("insert 1 table failed: \(database.lastErrorMessage())")
        //        }
        //
        //        if !database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", withArgumentsInArray: ["e", "f", "g"]) {
        //            println("insert 2 table failed: \(database.lastErrorMessage())")
        //        }
        
        
//        if let rs = database.executeQuery("select x, y, z from test", withArgumentsInArray: nil) {
//            while rs.next() {
//                let x = rs.stringForColumn("x")
//                let y = rs.stringForColumn("y")
//                let z = rs.stringForColumn("z")
//                println("x = \(x); y = \(y); z = \(z)")
//            }
//        } else {
//            println("select failed: \(database.lastErrorMessage())")
//        }

    }
    
    let pendingOperations = PendingOperations()
    func start(#updateViews:()->()){
        if City.getInstance.city_name == nil {
            City.getInstance.updateLoction()
            return
        }
        let downloader = WeatherDownloader()
        downloader.completionBlock = {
            if downloader.cancelled{
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                updateViews()
            })
        }
        pendingOperations.imagesQueue.addOperation(downloader)
    }
    
//    func startSignal() -> RACSignal{
//        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
//            self.start(updateViews: { () -> () in
//                if self.weather.state == Weather.WeatherState.Stored{
//                    subscriber.sendNext(true)
//                }else{
//                    subscriber.sendError(nil)
//                }
//                subscriber.sendCompleted()
//            })
//            
//            return RACDisposable(block: { () -> Void in
//                // cancel all operation
//            })
//        }).doError({ (error:NSError!) -> Void in
//            println(error.description)
//        })
//    }
    
//    func fetchCurrentWeatherForLocation(name:String) -> RACSignal{
//        
//        self.weather.city = name
//
//        return self.startSignal().map({ (complete:AnyObject!) -> AnyObject! in
//            return complete
//        })
//    }
//    func fetchDailyWeatherForLocation(name:String) -> RACSignal{
//        
//        self.weather.city = name
//        
//        return self.startSignal().map({ (complete:AnyObject!) -> AnyObject! in
//            return complete
//        })
//    }
//    func fetchWeekWeatherForLocation(name:String) -> RACSignal{
//        
//        self.weather.city = name
//        
//        return self.startSignal().map({ (complete:AnyObject!) -> AnyObject! in
//            return complete
//        })
//    }

    
//    func waitForWeather(#updateViews:()->()){
//        let idle = IdleOperation()
//        idle.completionBlock = {
//            if idle.cancelled {
//                return 
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                updateViews()
//            })
//        }
//        pendingOperations.idleQueue.addOperation(idle)
//    }
//    
//    func waitForDailyWeather(#updateViews:()->()){
//        let idle = IdleDailyOperation()
//        idle.completionBlock = {
//            if idle.cancelled {
//                return
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                updateViews()
//            })
//        }
//        pendingOperations.idleQueue.addOperation(idle)
//    }
//    func waitForWeekWeather(#updateViews:()->()){
//        let idle = IdleWeekOperation()
//        idle.completionBlock = {
//            if idle.cancelled {
//                return
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                updateViews()
//            })
//        }
//        pendingOperations.idleQueue.addOperation(idle)
//    }
//    
//    func start(){
//        self.start(updateViews: {})
//    }

    func open(){
        if !database.open() {
            println("Unable to open database")
        }
    }
    
    func getWeatherIcon(name:String)->UIImage?{
        
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitHour , fromDate: now)
        var hour =  components.hour
        return getWeatherIcon(name,hour: hour)
    }
    
    func getWeatherIcon(name:String,hour:Int)->UIImage?{
        var idx = find(Global.WeatherDefault, name)
        if idx != nil {
            if hour >= 19 || hour <= 6 {
                return UIImage(named: Global.WeatherDefaultNightIcon[idx!])
            }else{
                return UIImage(named: Global.WeatherDefaultDayIcon[idx!])
            }
        }else{
            return stringReverse(name)
        }
    }
    func stringReverse(name:NSString)->UIImage!{
        if name == "" {
            return UIImage(named: Global.weather_icon_home[Global.noti_icon_night_clear_idx])
        }
        var w_1:String = "notpossible"
        var w_2:String = "notpossible"
        var w_3:String = "notpossible"
        var len = name.length
        
        w_1 = name.substringToIndex(1)
        if (len >= 2){
            w_2 = name.substringToIndex(2)
        }
        if (len >= 3){
            w_3 = name.substringToIndex(3);
        }
        
        var b_1:Int? = find(Global.weather_icon_text, w_1)
        var b_2:Int? = find(Global.weather_icon_text, w_2)
        var b_3:Int? = find(Global.weather_icon_text, w_3)
        var w_idx:Int = 0
        if (b_1 != nil || b_2 != nil || b_3 != nil) {
            if (b_3 != nil ) {
                w_idx = b_3!
            } else if (b_2 != nil ) {
                w_idx = b_2!
            } else if (b_1 != nil) {
                w_idx = b_1!
            }
        }
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitHour , fromDate: now)
        var hour =  components.hour

        if hour >= 19 && hour <= 6 {
            if (w_idx == 0) {
                w_idx = Global.noti_icon_night_clear_idx;
            }
            if (w_idx >= Global.noti_wicon_cloudy_up
                && w_idx <= Global.noti_wicon_cloudy_down) {
                    w_idx = Global.noti_icon_night_cloudy_idx;
            }
            if (w_idx >= Global.noti_wicon_rain_up
                && w_idx <= Global.noti_wicon_rain_down) {
                    w_idx = Global.noti_icon_night_rain_idx;
            }
            if (w_idx >= Global.noti_wicon_snow_up
                && w_idx <= Global.noti_wicon_snow_down) {
                    w_idx = Global.noti_icon_night_snow_idx;
            }

        }else{
            if (w_idx == Global.noti_icon_night_snow_idx) {
                w_idx = Global.noti_icon_daytime_snow_idx;
            }
        }
        
        return UIImage(named: Global.weather_icon_home[w_idx])
//        int hournow = cal.get(Calendar.HOUR_OF_DAY);
//        if (w_idx >= CategorySet.noti_wicon_night_start_idx) {
//            if (hournow > 19 || hournow < 8) {
//                
//            } else {
//                if (w_idx == CategorySet.noti_icon_night_snow_idx) {
//                    w_idx = CategorySet.noti_icon_daytime_snow_idx;
//                }
//            }
//        }
//        
//        if (hournow > 19 || hournow < 8) {
//
//        }
//        
//        // Log.e("d", "" + w_idx);
//        remoteView.setImageViewResource(R.id.noti_icon,
//            CategorySet.weather_icon_noti[w_idx]);
    }
    
    func ios8() -> Bool {
        return UIDevice.currentDevice().systemVersion.compare("8.0", options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    func close(){
        if database.isAccessibilityElement {
            database.close()
        }
    }
    
    
}