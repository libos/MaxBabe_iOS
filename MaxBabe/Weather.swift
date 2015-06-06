//
//  Weather.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

//$keys = array('temp','weather','updatetime','rtemp','fengxiang','fenglevel','humidity','rweather',
//    'aqi',"today_weather","today_temp",'day_weather','night_weather','day_temp','night_temp',
//    'tomo_weather','tomo_temp','next_day_weather','next_night_weather','next_day_temp',
//    'next_night_temp','weather_detail','has_alarm');
//array('alarm_type','alarm_level','alarm_issuetime','alram_content');
import Foundation

class Weather {
    
    enum WeatherState {
        case Idle,Start,Downloading,Stored
    }
    struct WeatherData {
        var temp : String?
        var weather : String?
        var updatetime : String?
        var rtemp : String?
        var fengxiang : String?
        var fenglevel : String?
        var humidity : String?
        var rweather : String?
        var aqi : Int?
        var today_weather : String?
        var day_weather : String?
        var night_weather : String?
        var day_temp : String?
        var night_temp : String?
        var tomo_weather : String?
        var tomo_temp : String?
        var next_day_weather:String?
        var next_night_weather : String?
        var next_day_temp : String?
        var next_night_temp : String?
        var weather_detail : String?
        var has_alarm : Int?
    }
    struct AlarmData {
        let alarm_type : String?
        let alarm_level : String?
        let alarm_issuetime : String?
        let alarm_content : String?
    }
    
    var state:WeatherState = WeatherState.Idle
    
    var data: WeatherData!
    var alarm : AlarmData?
    
    
    
    class storeData:AnyObject {
        let data:WeatherData?
        let alarm:AlarmData?
        init(data:WeatherData,alarm:AlarmData?)
        {
            self.data = data
            self.alarm = alarm
        }
    }
    
    init(temp:String,weather:String,updatetime:String,rtemp : String, fengxiang : String, fenglevel : String, humidity : String, rweather : String, aqi : Int, today_weather : String, day_weather : String, night_weather : String, day_temp : String, night_temp : String, tomo_weather : String, tomo_temp : String, next_day_weather:String, next_night_weather : String, next_day_temp : String, next_night_temp : String, weather_detail : String, has_alarm : Int){
        
        data = WeatherData(temp: temp, weather: weather, updatetime: updatetime, rtemp: rtemp, fengxiang: fengxiang, fenglevel: fenglevel, humidity: humidity, rweather: rweather, aqi: aqi, today_weather: today_weather, day_weather: day_weather, night_weather: night_weather, day_temp: day_temp, night_temp: night_temp, tomo_weather: tomo_weather, tomo_temp: tomo_temp, next_day_weather: next_day_weather, next_night_weather: next_night_weather, next_day_temp: next_day_temp, next_night_temp: next_night_temp, weather_detail: weather_detail, has_alarm: has_alarm)
        if has_alarm == 0 {
            alarm = nil
        }else{
            alarm = nil
        }
    }
    init(){
        data = WeatherData()
        self.updateSelf()
    }
    
    class var getInstance:Weather {
        
        struct Singleton {
            static let instance = Weather()
        }
        return Singleton.instance
    }
    
    
    func updateSelf() {
        
        // get data
        state = WeatherState.Start
        var city = "北京"
        var auth : String =  city +  ". maxtain .all. mybabe "
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        
        let hour = String(format: "%02d",  components.hour)
        
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        var params:Dictionary = ["id":city,"auth":auth.md5,"type":"all","user":"1","hour":hour,"month":month,"day":day]
        
        //        println(params.description)
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.GET(
            "http://api.babe.maxtain.com/get_data.php", parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
                println(response.description)
                self.state = .Downloading
                self.updateSuccess(response as! NSDictionary!)
            },
            failure: {(operation : AFHTTPRequestOperation!, error : NSError!) in
                println(error.localizedDescription)
            }
        )
        
        // parse
        // init self
        
        // get into self
        
    }
    
    
    
    func updateSuccess(json : NSDictionary!){
        
        if (json["state"] as? String != "err") {
            self.data.temp = json["temp"] as? String
            self.data.weather = json["weather"] as? String
            self.data.updatetime = json["updatetime"] as? String
            self.data.rtemp = json["rtemp"] as? String
            self.data.fengxiang = json["fengxiang"] as? String
            self.data.fenglevel = json["fenglevel"] as? String
            self.data.humidity = json["humidity"] as? String
            self.data.rweather = json["rweather"] as? String
            self.data.aqi = (json["aqi"] as? String)?.toInt()
            self.data.today_weather = json["today_weather"] as? String
            self.data.day_weather = json["day_weather"] as? String
            self.data.night_weather = json["night_weather"] as? String
            self.data.day_temp = json["day_temp"] as? String
            self.data.night_temp = json["night_temp"] as? String
            self.data.tomo_weather = json["tomo_weather"] as? String
            self.data.tomo_temp = json["tomo_temp"] as? String
            self.data.next_day_weather = json["next_day_weather"] as? String
            self.data.next_night_weather = json["today_weather"] as? String
            self.data.next_day_temp = json["next_day_temp"] as? String
            self.data.next_night_temp = json["next_night_temp"] as? String
            self.data.weather_detail = json["weather_detail"] as? String
            self.data.has_alarm = (json["has_alarm"] as? String)?.toInt()
            //            println(self.data.temp!)
            //            println(self.data.next_day_weather!)
            
            //            let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            //            let store:storeData = storeData(data: self.data, alarm: self.alarm)
            ////            let arr:NSMutableArray = NSMutableArray(capacity: 1)
            ////            arr.addObject(anObject: AnyObject)
            //            st.setValue(store, forKey: Global.weatherData)
            //            st.synchronize()
            state = WeatherState.Stored
            let pics = Pics.getInstance
            pics.updateSelf()
        }
    }
    
    // every load
    
    // every hour async update daily
    // if have wrong download
    
    func getDaily() -> Dictionary<Int,(Int,String)>?{
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        let last_time = st.stringForKey(Global.dailyUpdateTime)
        var ret:Dictionary<String,Dictionary<String,String>>!
        if last_time == "\(year)\(month)\(day)"{
            ret = st.dictionaryForKey(Global.dailyData) as? Dictionary<String,Dictionary<String,String>>
        }else{
            let pendingOperations = PendingOperations()
            let downloader = ForecastDownloader()
            downloader.completionBlock = {
                if downloader.cancelled{
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    
                })
            }
            pendingOperations.forcastQueue.addOperation(downloader)
            
            //self.downloadDaily()// or use do it async
            return nil
        }
        if ret == nil{
            return nil
        }
        
        var x:Dictionary<Int,(Int,String)> = [:]
        for (hour:String,data:Dictionary<String,String>) in ret{
            if data["t"] == "false"{
                
            }else{
                x.updateValue((data["t"]!.toInt()!,data["w"]!), forKey: hour.toInt()!)
            }
        }
        if x[0] == nil{
            let defv = x[x.keys.first!]
            for (hour:String,data:Dictionary<String,String>) in ret{
                if data["t"] == "false"{
                    x.updateValue(defv!, forKey: hour.toInt()!)
                }
            }
        }
        return x
        
        //        st.synchronize()
        
    }
    
    
    func downloadDaily(){
        var city = "北京"
        
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        var auth : String =  city +  ". maxtain" + day + " . mybabe "
        var params:Dictionary = ["city":city,"auth":auth.md5,"month":month,"date":day]
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.GET(
            "http://api.babe.maxtain.com/get_daily.php", parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
                println(response.description)
                //                if response is Dictionary<String,Dictionary<String,String>>{
                self.updateDaily(response as! Dictionary<String,Dictionary<String,String>>!)
                //                }
            },
            failure: {(operation : AFHTTPRequestOperation!, error : NSError!) in
                println(error.localizedDescription)
            }
        )
    }
    func updateDaily(json : Dictionary<String,Dictionary<String,String>>?){
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        st.setObject(json, forKey: Global.dailyData)
        st.setValue("\(year)\(month)\(day)", forKey: Global.dailyUpdateTime)
        st.synchronize()
        
    }
    
    
    func getWeek() -> Dictionary<Int,(Int,Int,String)>?{
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        let last_time = st.stringForKey(Global.dailyUpdateTime)
        var ret:Dictionary<String,Dictionary<String,String>>!
        if last_time == "\(year)\(month)\(day)"{
            ret = st.dictionaryForKey(Global.dailyData) as? Dictionary<String,Dictionary<String,String>>
        }else{
            let pendingOperations = PendingOperations()
            let downloader = ForecastDownloader()
            downloader.completionBlock = {
                if downloader.cancelled{
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    
                })
            }
            pendingOperations.forcastQueue.addOperation(downloader)
            
            //self.downloadDaily()// or use do it async
            return nil
        }
        if ret == nil{
            return nil
        }
        
        var x:Dictionary<Int,(Int,Int,String)> = [:]
        var high:Int?
        var low:Int?
        var temp:Int?
        var weather:String?
        var day_weather:String?
        var night_weather:String?
        
        weather = self.data.day_weather
        if self.data.day_weather! != self.data.night_weather!  {
            high = find(Global.WeatherDefault, self.data.day_weather!)
            low = find(Global.WeatherDefault, self.data.night_weather!)
            if high < low {
                weather = self.data.night_weather!
            }
        }
        high = self.data.day_temp?.toInt()!
        low = self.data.night_temp?.toInt()!
        if high < low {
            temp = high
            high = low
            low = temp
        }
        x.updateValue((high!,low!,weather!), forKey: 0)
        for (idx:String,data:Dictionary<String,String>) in ret{

            //     {"1":{"day_weather":"\u9634","night_weather":"\u591a\u4e91","day_temp":"19","night_temp":"32 "},"2":{"day_weather":"\u96f7\u9635\u96e8","night_weather":"\u9634","day_temp":"18","night_temp":"30 "},"3":{"day_weather":"\u6674","night_weather":"\u591a\u4e91","day_temp":"20","night_temp":"32 "},"4":{"day_weather":"\u96f7\u9635\u96e8","night_weather":"\u96f7\u9635\u96e8","day_temp":"19","night_temp":"30 "}}#   ┌─[root@LiberLiu] - [/alidata/www/BebeServ] - [2015-06-05 10:34:17]
            
            day_weather = data["day_weather"]
            night_weather = data["night_weather"]
            
            if day_weather == night_weather && (day_weather != nil) {
                weather = day_weather
            }else{
                high = find(Global.WeatherDefault, day_weather!)
                low = find(Global.WeatherDefault,night_weather!)
                weather = day_weather
                if high < low {
                    weather = night_weather
                }
            }
            high = data["day_temp"]?.toInt()
            low = data["night_temp"]?.toInt()
            if high < low {
                temp = high
                high = low
                low = temp
            }
            
            //                WeatherDefault
            
            x.updateValue((high!,low!,weather!), forKey: idx.toInt()!)
            
        }
        //        if x[0] == nil{
        //            let defv = x[x.keys.first!]
        //            for (hour:String,data:Dictionary<String,String>) in ret{
        //                if data["t"] == "false"{
        //                    x.updateValue(defv!, forKey: hour.toInt()!)
        //                }
        //            }
        //        }
        return x
        
        
    }
    func downloadWeek(){
        var city = "北京"
        
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        var auth : String =  city +  ". maxtain" + day + " . mybabe "
        var params:Dictionary = ["city":city,"auth":auth.md5,"month":month,"date":day]
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.GET(
            "http://api.babe.maxtain.com/get_week.php", parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
                println(response.description)
                self.updateWeek(response as! Dictionary<String,Dictionary<String,String>>!)
            },
            failure: {(operation : AFHTTPRequestOperation!, error : NSError!) in
                println(error.localizedDescription)
            }
        )
    }
    func updateWeek(json : Dictionary<String,Dictionary<String,String>>?){
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        st.setObject(json, forKey: Global.weekData)
        st.setValue("\(year)\(month)\(day)", forKey: Global.weekUpdateTime)
        st.synchronize()
    }
    
    
    func getFromStore(){
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let store:storeData = st.valueForKey(Global.weatherData) as! storeData
        self.data = store.data
        self.alarm = store.alarm
    }
    
    func nowFilter() -> String!{
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMonth | .CalendarUnitWeekday, fromDate: now)
        
        let hour = String(format: "%02d",  components.hour)
        let month = String(format: "%02d", components.month)
        let week  = String(format: "%02d", components.weekday)
        
        let hour_filter = " and ((ge_hour <= \(hour) and le_hour >= \(hour) and (ge_hour <= le_hour)) or ((ge_hour > le_hour) and ((ge_hour <= \(hour) and \(hour) < 25) or (\(hour) >= 0 and le_hour >= \(hour)))))"
        let week_filter = " and ((ge_week <= \(week) and le_week >= \(week) and (ge_week <= le_week)) or ((ge_week > le_week) and ((ge_week <= \(week) and \(week) <= 7) or (le_week >= \(week) and \(week) >= 0))))"
        let month_filter = " and ((ge_month <= \(month) and le_month >= \(month) and (ge_month <= le_month)) or ((ge_month > le_month) and ((ge_month <= \(month) and \(month) >= 31) or (le_month >=\(month) and \(month) >=0 ))))"
        
        let weather = self.getWeather()
        
        let weather_filter = " ((weather = '*') or (weather = '任意天气') or (weather like '%\(weather)%') or ('\(weather)' like '%' || weather || '%'))"
        
        let temp_filter = " and (ge_temp <= \(self.getTemp()!) and le_temp >= \(self.getTemp()!))"
        let aqi_filter = " and (ge_aqi <= \(self.data.aqi!) and le_aqi >= \(self.data.aqi!))"
        
        let filter =  weather_filter + hour_filter + week_filter + month_filter + temp_filter + aqi_filter
        return filter;
        
    }
    
    func getWeather() -> String? {
        if self.data.weather == nil {
            return self.data.today_weather
        }else{
            return self.data.weather
        }
    }
    
    func getTemp() -> String? {
        if self.data.temp == nil {
            return self.data.rtemp
        }else{
            return self.data.temp
        }
    }
    //    public static String getNowFilter(Context context) {
    //    WeatherData wea = loadNowWeather(context);
    //    Calendar cl = Calendar.getInstance();
    //
    //    int nowhour = cl.get(Calendar.HOUR_OF_DAY);
    //    int nowdate = cl.get(Calendar.DAY_OF_WEEK) - 1;
    //    int nowmonth = cl.get(Calendar.DAY_OF_MONTH) + 1;
    //    String hour_filter = String.format(" and ("
    //				+ "(ge_hour <= %d and le_hour >= %d and (ge_hour <= le_hour))"
    //				+ " or ((ge_hour > le_hour) "
    //				+ "and ((ge_hour <= %d and %d < 25) "
    //				+ "or (%d >= 0 and le_hour >= %d))" + "))", nowhour, nowhour,
    //				nowhour, nowhour, nowhour, nowhour);
    //    String week_filter = String.format(" and ( "
    //				+ "(ge_week <= %d and le_week >= %d and (ge_week <= le_week)) "
    //				+ "or ((ge_week > le_week) "
    //				+ "and ((ge_week <= %d and %d <= 7) "
    //				+ "or (le_week >= %d and %d >= 0))" + "))", nowdate, nowdate,
    //				nowdate, nowdate, nowdate, nowdate);
    //    String month_filter = String
    //				.format(" and ( "
    //    + "(ge_month <= %d and le_month >= %d and (ge_month <= le_month)) "
    //    + "or ((ge_month > le_month) "
    //    + "and ((ge_month <= %d and %d >= 31) "
    //    + "or (le_month >=%d and %d >=0 ))" + "))", nowmonth,
    //    nowmonth, nowmonth, nowmonth, nowmonth, nowmonth);
    //
    //    String weather_filter = "";
    //    String nowweather = StringUtils.isNotEmpty(wea.today_weather)
    //				&& StringUtils.isNotBlank(wea.today_weather) ? wea.today_weather
    //				: wea.weather;
    //    if (StringUtils.isNotEmpty(nowweather)
    //				&& StringUtils.isNotBlank(nowweather)) {
    //    try {
    //				weather_filter = String.format(" ((weather = '*') "
    //    + "or (weather = '任意天气') or (weather like '%s') "
    //    + "or ('%s' like '%s' || weather || '%s'))", "%"
    //    + nowweather + "%", nowweather, "%", "%");
    //    } catch (NumberFormatException e) {
    //				weather_filter = "";
    //
    //    }
    //    }
    //
    //    String temp_filter = "";
    //    try {
    //    int temp_inte = Integer.parseInt(wea.temp);
    //    temp_filter = String.format(
    //    " and (ge_temp <= %d and le_temp >= %d)", temp_inte,
    //    temp_inte);
    //    } catch (NumberFormatException e) {
    //    temp_filter = "";
    //    }
    //
    //    String aqi_filter = "";
    //    if (!StringUtils.isEmpty(wea.aqi) && NumberUtils.isNumber(wea.aqi)) {
    //
    //    int aqi_int = Integer.parseInt(wea.aqi);
    //    aqi_filter = String.format(" and (ge_aqi <=%d and le_aqi >= %d)",
    //    aqi_int, aqi_int);
    //    } else {
    //    aqi_filter = "";
    //    }
    //
    //    String filter = "" + weather_filter + hour_filter + week_filter
    //				+ month_filter + temp_filter ;//+ aqi_filter;
    //
    //    return filter;
    //    }
    func save(){
        
        
        
    }
    
}