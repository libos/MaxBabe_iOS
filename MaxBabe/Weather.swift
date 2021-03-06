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

class Weather:NSObject {
    
    let globalUpdateTimeFlag = "globalUpdateTimeFlag"
    let globalWeatherTemp = "globalWeatherTemp"
    let globalWeatherWeather = "globalWeatherWeather"
    let globalWeatherRTemp = "globalWeatherRTemp"
    let globalWeatherRWeather = "globalWeatherRWeather"
    let globalTodayWeather = "globalTodayWeather"
    let globalDayWeather = "globalDayWeather"
    let globalNightWeahter = "globalNightWeahter"
    let globalDayTemp = "globalDayTemp"
    let globalNightTemp = "globalNightTemp"
    let globalNextDayWeather = "globalNextDayWeather"
    let globalNextNightWeather = "globalNextNightWeather"
    let globalNextDayTemp = "globalNextDayTemp"
    let globalNextNightTemp = "globalNextNightTemp"
    
    enum WeatherState {
        case Idle,Start,Downloading,Stored,DailyDone,WeekDone
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
        
        var cy_realtime_aqi : Int?
        var cy_realtime_humidity : String?
        var cy_realtime_windlevel : String?
        var cy_realtime_temperature : String?
        
        var cy_sunrise : String?
        var cy_sunset : String?
        var cy_tempmax : String?
        var cy_tempavg : String?
        var cy_tempmin : String?
        
        var cy_weather : String?
        
        var cy_windmax : String?
        var cy_windavg : String?
        var cy_windmin : String?
        
        var cy_humiditymax : String?
        var cy_humidityavg : String?
        var cy_humiditymin : String?
        
    }
    struct AlarmData {
        let alarm_type : String?
        let alarm_level : String?
        let alarm_issuetime : String?
        let alarm_content : String?
    }
    var dailyData:Dictionary<Int,(Int,String)>?
    var weekData:Dictionary<Int,(Int,Int,String)>?
    var state_p:String = ".Idle"
    var state:String {
        get{
            return state_p
        }
        set(newValue){
            self.willChangeValueForKey("state")
            state_p = newValue
            self.didChangeValueForKey("state")
        }
    }
    var dailyState_p:String = ".Idle"
    var weekState_p:String = ".Idle"
    var dailyState:String {
        get{
            return dailyState_p
        }
        set(newValue){
            self.willChangeValueForKey("dailyState")
            dailyState_p = newValue
            self.didChangeValueForKey("dailyState")
        }
    }
    var weekState:String {
        get{
            return weekState_p
        }
        set(newValue){
            self.willChangeValueForKey("weekState")
            weekState_p = newValue
            self.didChangeValueForKey("weekState")
            
        }
    }
    
    var data: WeatherData!
    var alarm : AlarmData?
    
    let city:City = City.getInstance
    var city_name:String?
    
    
//    init(temp:String,weather:String,updatetime:String,rtemp : String, fengxiang : String, fenglevel : String, humidity : String, rweather : String, aqi : Int, today_weather : String, day_weather : String, night_weather : String, day_temp : String, night_temp : String, tomo_weather : String, tomo_temp : String, next_day_weather:String, next_night_weather : String, next_day_temp : String, next_night_temp : String, weather_detail : String, has_alarm : Int){
//        
//        data = WeatherData()
//        //        temp: temp, weather: weather, updatetime: updatetime, rtemp: rtemp, fengxiang: fengxiang, fenglevel: fenglevel, humidity: humidity, rweather: rweather, aqi: aqi, today_weather: today_weather, day_weather: day_weather, night_weather: night_weather, day_temp: day_temp, night_temp: night_temp, tomo_weather: tomo_weather, tomo_temp: tomo_temp, next_day_weather: next_day_weather, next_night_weather: next_night_weather, next_day_temp: next_day_temp, next_night_temp: next_night_temp, weather_detail: weather_detail, has_alarm: has_alarm
//        if has_alarm == 0 {
//            alarm = nil
//        }else{
//            alarm = nil
//        }
//    }
    override init(){
        self.data = WeatherData()
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data_store:NSDictionary? = st.valueForKey(Global.weatherData) as? NSDictionary
        if data_store != nil {
            self.data.temp = data_store?.valueForKey("temp") as? String
            self.data.weather = data_store?.valueForKey("weather") as? String
            self.data.updatetime = data_store?.valueForKey("updatetime") as? String
            self.data.rtemp = data_store?.valueForKey("rtemp") as? String
            self.data.fengxiang = data_store?.valueForKey("fengxiang") as? String
            self.data.fenglevel = data_store?.valueForKey("fenglevel") as? String
            self.data.humidity = data_store?.valueForKey("humidity") as? String
            self.data.rweather = data_store?.valueForKey("rweather") as? String
            self.data.aqi = (data_store?.valueForKey("aqi") as? String)?.toInt()
            self.data.today_weather = data_store?.valueForKey("today_weather") as? String
            self.data.day_weather = data_store?.valueForKey("day_weather") as? String
            self.data.night_weather = data_store?.valueForKey("night_weather") as? String
            self.data.day_temp = data_store?.valueForKey("day_temp") as? String
            self.data.night_temp = data_store?.valueForKey("night_temp") as? String
            self.data.tomo_weather = data_store?.valueForKey("tomo_weather") as? String
            self.data.tomo_temp = data_store?.valueForKey("tomo_temp") as? String
            self.data.next_day_weather = data_store?.valueForKey("next_day_weather") as? String
            self.data.next_night_weather = data_store?.valueForKey("today_weather") as? String
            self.data.next_day_temp = data_store?.valueForKey("next_day_temp") as? String
            self.data.next_night_temp = data_store?.valueForKey("next_night_temp") as? String
            self.data.weather_detail = data_store?.valueForKey("weather_detail") as? String
            self.data.has_alarm = (data_store?.valueForKey("has_alarm") as? String)?.toInt()
            
            self.data.cy_realtime_aqi = (data_store?.valueForKey("cy_realtime_aqi") as? String)?.toInt()
            self.data.cy_realtime_humidity = data_store?.valueForKey("cy_realtime_humidity") as? String
            self.data.cy_realtime_windlevel = data_store?.valueForKey("cy_realtime_windlevel") as? String
            self.data.cy_realtime_temperature = data_store?.valueForKey("cy_realtime_temperature") as? String
            
            self.data.cy_sunrise = data_store?.valueForKey("cy_sunrise") as? String
            self.data.cy_sunset = data_store?.valueForKey("cy_sunset") as? String
            self.data.cy_tempmax = data_store?.valueForKey("cy_tempmax") as? String
            self.data.cy_tempavg = data_store?.valueForKey("cy_tempavg") as? String
            self.data.cy_tempmin = data_store?.valueForKey("cy_tempmin") as? String
            
            self.data.cy_weather = data_store?.valueForKey("cy_weather") as? String
            
            self.data.cy_windmax = data_store?.valueForKey("cy_windmax") as? String
            self.data.cy_windavg = data_store?.valueForKey("cy_windavg") as? String
            self.data.cy_windmin = data_store?.valueForKey("cy_windmin") as? String
            
            self.data.cy_humiditymax = data_store?.valueForKey("cy_humiditymax") as? String
            self.data.cy_humidityavg = data_store?.valueForKey("cy_humidityavg") as? String
            self.data.cy_humiditymin = data_store?.valueForKey("cy_humiditymin") as? String
        }else{
            self.data.temp = "0"
            self.data.weather = "晴"
            self.data.updatetime = "0504"
            self.data.rtemp = "0"
            self.data.fengxiang = "南风"
            self.data.fenglevel = "2"
            self.data.humidity = "20"
            self.data.rweather = "晴"
            self.data.aqi = 48
            self.data.today_weather = "晴"
            self.data.day_weather = "晴"
            self.data.night_weather = "晴"
            self.data.day_temp = "0"
            self.data.night_temp = "0"
            self.data.tomo_weather = "晴"
            self.data.tomo_temp = "0~0"
            self.data.next_day_weather = "晴"
            self.data.next_night_weather = "晴"
            self.data.next_day_temp = "0"
            self.data.next_night_temp = "0"
            self.data.weather_detail = "晴"
            self.data.has_alarm = 0
            
            self.data.cy_realtime_aqi = 50
            self.data.cy_realtime_humidity = "20"
            self.data.cy_realtime_windlevel = "2"
            self.data.cy_realtime_temperature = "10"
            
            self.data.cy_sunrise = "6:00"
            self.data.cy_sunset = "18:00"
            self.data.cy_tempmax = "10"
            self.data.cy_tempavg = "10"
            self.data.cy_tempmin = "10"
            
            self.data.cy_weather = "晴"
            
            self.data.cy_windmax = "2"
            self.data.cy_windavg = "2"
            self.data.cy_windmin = "2"
            
            self.data.cy_humiditymax = "20"
            self.data.cy_humidityavg = "20"
            self.data.cy_humiditymin = "20"
        }
        super.init()
        if city.city_name != nil {
            self.city_name  = city.cleanCityName()!
            self.updateSelf()
        }
    }
    
    class var getInstance:Weather {
        struct Singleton {
            static let instance = Weather()
        }
        return Singleton.instance
    }
    
    func updateCityName(){
        if self.city.city_name != nil {
            self.city_name  = self.city.cleanCityName()!
        }
    }
    
    func updateSelf() {
        updateCityName()
        // get data
        state = ".Start"
        var auth : String =  self.city_name! +  ". maxtain .all. mybabe "
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        
        let hour = String(format: "%02d",  components.hour)
        
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        var params:Dictionary = ["id":self.city_name!,"auth":auth.md5,"type":"all","user":"1","hour":hour,"month":month,"day":day]
        
        //        println(params.description)
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.GET(
            "http://apibabe.maxtain.com/get_data_iphone.php", parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
//                                println(response.description)
                self.state = ".Downloading"
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
            
            self.data.cy_realtime_aqi = (json["cy_realtime_aqi"] as? String)?.toInt()
            self.data.cy_realtime_humidity = json["cy_realtime_humidity"] as? String
            self.data.cy_realtime_windlevel = json["cy_realtime_windlevel"] as? String
            self.data.cy_realtime_temperature = json["cy_realtime_temperature"] as? String
            
            self.data.cy_sunrise = json["cy_sunrise"] as? String
            self.data.cy_sunset = json["cy_sunset"] as? String
            self.data.cy_tempmax = json["cy_tempmax"] as? String
            self.data.cy_tempavg = json["cy_tempavg"] as? String
            self.data.cy_tempmin = json["cy_tempmin"] as? String
            
            self.data.cy_weather = json["cy_weather"] as? String
            
            self.data.cy_windmax = json["cy_windmax"] as? String
            self.data.cy_windavg = json["cy_windavg"] as? String
            self.data.cy_windmin = json["cy_windmin"] as? String
            
            self.data.cy_humiditymax = json["cy_humiditymax"] as? String
            self.data.cy_humidityavg = json["cy_humidityavg"] as? String
            self.data.cy_humiditymin = json["cy_humiditymin"] as? String
            
            let pics = Pics.getInstance
            pics.city = self.city_name
            pics.updateSelf()
            
            //            println(self.data.temp!)
            //            println(self.data.next_day_weather!)
            
            let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var store_data:NSMutableDictionary = NSMutableDictionary()
            store_data.setValue(self.data.temp, forKey: "temp")
            store_data.setValue(self.data.weather, forKey: "weather")
            store_data.setValue(self.data.updatetime, forKey: "updatetime")
            store_data.setValue(self.data.rtemp, forKey: "rtemp")
            store_data.setValue(self.data.fengxiang, forKey: "fengxiang")
            store_data.setValue(self.data.fenglevel, forKey: "fenglevel")
            store_data.setValue(self.data.humidity, forKey: "humidity")
            store_data.setValue(self.data.rweather, forKey: "rweather")
            store_data.setValue(self.data.aqi, forKey: "aqi")
            store_data.setValue(self.data.today_weather, forKey: "today_weather")
            store_data.setValue(self.data.day_weather, forKey: "day_weather")
            store_data.setValue(self.data.night_weather, forKey: "night_weather")
            store_data.setValue(self.data.day_temp, forKey: "day_temp")
            store_data.setValue(self.data.night_temp, forKey: "night_temp")
            store_data.setValue(self.data.tomo_weather, forKey: "tomo_weather")
            store_data.setValue(self.data.tomo_temp, forKey: "tomo_temp")
            store_data.setValue(self.data.next_day_weather, forKey: "next_day_weather")
            store_data.setValue(self.data.next_night_weather, forKey: "next_night_weather")
            store_data.setValue(self.data.next_day_temp, forKey: "next_day_temp")
            store_data.setValue(self.data.next_night_temp, forKey: "next_night_temp")
            store_data.setValue(self.data.weather_detail, forKey: "weather_detail")
            store_data.setValue(self.data.has_alarm, forKey: "has_alarm")
            
            store_data.setValue(self.data.cy_realtime_aqi, forKey: "cy_realtime_aqi")
            store_data.setValue(self.data.cy_realtime_humidity, forKey: "cy_realtime_humidity")
            store_data.setValue(self.data.cy_realtime_windlevel, forKey: "cy_realtime_windlevel")
            store_data.setValue(self.data.cy_realtime_temperature, forKey: "cy_realtime_temperature")
            
            store_data.setValue(self.data.cy_sunrise, forKey: "cy_sunrise")
            store_data.setValue(self.data.cy_sunset, forKey: "cy_sunset")
            store_data.setValue(self.data.cy_tempmax, forKey: "cy_tempmax")
            store_data.setValue(self.data.cy_tempavg, forKey: "cy_tempavg")
            store_data.setValue(self.data.cy_tempmin, forKey: "cy_tempmin")
            
            store_data.setValue(self.data.cy_weather, forKey: "cy_weather")
            
            store_data.setValue(self.data.cy_windmax, forKey: "cy_windmax")
            store_data.setValue(self.data.cy_windavg, forKey: "cy_windavg")
            store_data.setValue(self.data.cy_windmin, forKey: "cy_windmin")
            
            store_data.setValue(self.data.cy_humiditymax, forKey: "cy_humiditymax")
            store_data.setValue(self.data.cy_humidityavg, forKey: "cy_humidityavg")
            store_data.setValue(self.data.cy_humiditymin, forKey: "cy_humiditymin")
            
            st.setValue(store_data, forKey: Global.weatherData)
            st.synchronize()
            
            
            let now = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
            
            st.setValue("\(components.year)\(components.month)\(components.day)\(self.city_name!)", forKey: globalUpdateTimeFlag)
            st.setValue(self.getTemp(), forKey: globalWeatherTemp)
            st.setValue(self.data.weather, forKey: globalWeatherWeather)
            st.setValue(self.data.rtemp, forKey: globalWeatherRTemp)
            st.setValue(self.data.rweather, forKey: globalWeatherRWeather)
            st.setValue(self.data.today_weather, forKey: globalTodayWeather)
            st.setValue(self.data.day_temp, forKey: globalDayTemp)
            st.setValue(self.data.day_weather, forKey: globalDayWeather)
            st.setValue(self.data.night_temp, forKey: globalNightTemp)
            st.setValue(self.data.night_weather, forKey: globalNightWeahter)
            st.setValue(self.data.next_day_temp, forKey: globalNextDayTemp)
            st.setValue(self.data.next_day_weather, forKey: globalNextDayWeather)
            st.setValue(self.data.next_night_temp, forKey: globalNextNightTemp)
            st.setValue(self.data.next_night_weather, forKey: globalNextNightWeather)
            
            st.synchronize()
            
            state = ".Stored"
            //            self.setState(".Stored")
            
        }
    }
    
    // every load
    
    // every hour async update daily
    // if have wrong download
    func getDaily() -> Dictionary<Int,(Int,String)>?{
        updateCityName()
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var now = NSDate()
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        let last_time = st.stringForKey(Global.dailyUpdateTime)
        var ret:Dictionary<String,Dictionary<String,String>>!
        if last_time == "\(year)\(month)\(day)\(city_name)"{
            ret = st.dictionaryForKey(Global.dailyData) as? Dictionary<String,Dictionary<String,String>>
        }else{
            ret = nil
        }
        let pendingOperations = PendingOperations()
        let downloader = ForecastDownloader()
        downloader.completionBlock = {
            if downloader.cancelled{
                return
            }
            //                self.dailyState = .Downloading
            dispatch_async(dispatch_get_main_queue(), {
                //                self.dailyState = ".Downloaded"
                //                self.setDailyState(".DailyDone")
                //                self.dailyState = ".DailyDone"
                
            })
        }
        pendingOperations.forcastQueue.addOperation(downloader)
        
        if ret == nil{
            return nil
        }
        
        var x:Dictionary<Int,(Int,String)> = [:]
        for (hour:String,data:Dictionary<String,String>) in ret{
            if data["t"] == ""{
                
            }else{
                x.updateValue((data["t"]!.toInt()!,data["w"]!), forKey: hour.toInt()!)
            }
        }
        
        if x.isEmpty {
            self.dailyState = ".Idle"
            st.setObject("", forKey: Global.dailyUpdateTime)
            st.synchronize()
            return nil
        }
        
        var defv = x[x.keys.first!]
        
        for (hour:String,data:Dictionary<String,String>) in ret{
            if data["t"] == ""{
                x.updateValue(defv!, forKey: hour.toInt()!)
            }else{
                defv = x[hour.toInt()!]
            }
        }
        self.dailyData = x
        self.dailyState = ".DailyDone"
        //        self.setDailyState(".DailyDone")
        return x
        
        //        st.synchronize()
        
    }
    func getDailyNoStateChange() -> Dictionary<Int,(Int,String)>?{
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var ret:Dictionary<String,Dictionary<String,String>>!
        ret = st.dictionaryForKey(Global.dailyData) as! Dictionary<String,Dictionary<String,String>>
        
        var x:Dictionary<Int,(Int,String)> = [:]
        for (hour:String,data:Dictionary<String,String>) in ret{
            if data["t"] == ""{
                
            }else{
                x.updateValue((data["t"]!.toInt()!,data["w"]!), forKey: hour.toInt()!)
            }
        }
        if x.isEmpty {
            self.dailyState = ".Idle"
            st.setObject("", forKey: Global.dailyUpdateTime)
            st.synchronize()
            return nil
        }
        var defv = x[x.keys.first!]
        
        for (hour:String,data:Dictionary<String,String>) in ret{
            if data["t"] == ""{
                x.updateValue(defv!, forKey: hour.toInt()!)
            }else{
                defv = x[hour.toInt()!]
            }
        }
        
        self.dailyData = x
        return x
        
    }
    
    
    func downloadDaily(){
        updateCityName()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        var auth : String =  self.city_name! +  ". maxtain" + day + " . mybabe "
        var params:Dictionary = ["city":self.city_name!,"auth":auth.md5,"month":month,"date":day]
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(
            "http://apibabe.maxtain.com/get_daily.php", parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
//                println(response.description)
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
        updateCityName()
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        st.setObject(json, forKey: Global.dailyData)
        st.setValue("\(year)\(month)\(day)\(city_name)", forKey: Global.dailyUpdateTime)
        st.synchronize()
        self.dailyState = ".Downloaded"
    }
    
    
    func getWeek() -> Dictionary<Int,(Int,Int,String)>?{
        updateCityName()
        self.weekState = ".Start"
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        let last_time = st.stringForKey(Global.weekUpdateTime)
        var ret:Dictionary<String,Dictionary<String,String>>!
        
        if last_time == "\(year)\(month)\(day)\(city_name)" && self.data.night_weather != nil{
            ret = st.dictionaryForKey(Global.weekData) as? Dictionary<String,Dictionary<String,String>>
        }else{
            ret = nil
        }
        let pendingOperations = PendingOperations()
        let downloader = ForecastDownloader()
        downloader.completionBlock = {
            if downloader.cancelled{
                return
            }
            //            self.weekState = .Downloading
            dispatch_async(dispatch_get_main_queue(), {
                
                //                self.setDailyState(".WeekDone")
            })
        }
        pendingOperations.forcastQueue.addOperation(downloader)
        
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
        
        weather = ""
        
        if  self.data.night_weather != nil{
            if self.data.day_weather == nil {
                self.data.day_weather = self.data.night_weather
            }
            if self.data.day_weather != self.data.night_weather  {
                high = find(Global.WeatherDefault, self.data.day_weather!)
                low = find(Global.WeatherDefault, self.data.night_weather!)
                if high < low {
                    weather = self.data.night_weather!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                }
            }else{
                weather = self.data.night_weather!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
        }
        high = self.data.day_temp?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
        low = self.data.night_temp?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
        
        if high != nil && low != nil {
            if high < low {
                temp = high
                high = low
                low = temp
            }
            st.setValue(low!, forKey: Global.WeatherLowTemp)
            st.setValue(high!, forKey: Global.WeatherHighTemp)
            st.synchronize()
            x.updateValue((high!,low!,weather!), forKey: 0)
        }else if high != nil {
            x.updateValue((high!,st.integerForKey(Global.WeatherLowTemp),"晴"), forKey: 0)
        }else if low != nil{
            x.updateValue((st.integerForKey(Global.WeatherHighTemp),low!,"晴"), forKey: 0)
        }else{
            x.updateValue((st.integerForKey(Global.WeatherHighTemp),st.integerForKey(Global.WeatherLowTemp),"晴"), forKey: 0)
        }
        
        //        x.updateValue((38,-10,"晴"), forKey: 0)
        for (idx:String,data:Dictionary<String,String>) in ret{
            
            day_weather = data["day_weather"]
            night_weather = data["night_weather"]
            if (night_weather == nil) {
                day_weather = self.getWeather()
                night_weather = self.data.night_weather
            }
            
            if day_weather == night_weather && (day_weather != nil) {
                weather = day_weather
            }else if (day_weather != nil) && (night_weather != nil){
                high = find(Global.WeatherDefault, day_weather!)
                low = find(Global.WeatherDefault, night_weather!)
                weather = day_weather
                if high < low {
                    weather = night_weather
                }
            }else{
                
            }
            high = data["day_temp"]?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
            low = data["night_temp"]?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
            if high < low {
                temp = high
                high = low
                low = temp
            }
            
            x.updateValue((high!,low!,weather!), forKey: idx.toInt()!)
        }
        
        self.weekData = x
        self.weekState = ".WeekDone"
        //        self.setDailyState(".WeekDone")
        return x
    }
    
    func getWeekNoStateChange() -> Dictionary<Int,(Int,Int,String)>?{
        
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var ret:Dictionary<String,Dictionary<String,String>>!
        ret = st.dictionaryForKey(Global.weekData) as! Dictionary<String,Dictionary<String,String>>
        
        var x:Dictionary<Int,(Int,Int,String)> = [:]
        var high:Int?
        var low:Int?
        var temp:Int?
        var weather:String?
        var day_weather:String?
        var night_weather:String?
        
        weather = ""
        
        if  self.data.night_weather != nil{
            if self.data.day_weather == nil {
                self.data.day_weather = self.data.night_weather
            }
            if self.data.day_weather != self.data.night_weather  {
                high = find(Global.WeatherDefault, self.data.day_weather!)
                low = find(Global.WeatherDefault, self.data.night_weather!)
                if high < low {
                    weather = self.data.night_weather!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                }
            }else{
                weather = self.data.night_weather!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
        }
        high = self.data.day_temp?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
        low = self.data.night_temp?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
        if high != nil && low != nil {
            if high < low {
                temp = high
                high = low
                low = temp
            }
            let chengyaojin = self.getTemp()?.toInt()
            if  chengyaojin > high {
                high = chengyaojin
            }
            if chengyaojin < low {
                low = chengyaojin
            }
            x.updateValue((high!,low!,weather!), forKey: 0)
        }else{
            //            x.updateValue((30,30,"晴"), forKey: 0)
        }
        
        for (idx:String,datax:Dictionary<String,String>) in ret{
            
            day_weather = datax["day_weather"]
            night_weather = datax["night_weather"]
            if (night_weather == nil) {
                day_weather = self.getWeather()
                night_weather = self.data.night_weather
            }
            
            if day_weather == night_weather && (day_weather != nil) {
                weather = day_weather
            }else if (day_weather != nil) && (night_weather != nil){
                high = find(Global.WeatherDefault, day_weather!)
                low = find(Global.WeatherDefault, night_weather!)
                weather = day_weather
                if high < low {
                    weather = night_weather
                }
            }else{
                
            }
            high = datax["day_temp"]?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
            low = datax["night_temp"]?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()
            if high < low {
                temp = high
                high = low
                low = temp
            }
            
            x.updateValue((high!,low!,weather!), forKey: idx.toInt()!)
            
        }
        self.weekData = x
        return x
        
        
    }
    
    func downloadWeek(){
        updateCityName()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: now)
        let year = "\(components.year)"
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        var auth : String =  self.city_name! +  ". maxtain" + day + " . mybabe "
        var params:Dictionary = ["city":self.city_name!,"auth":auth.md5,"year":year,"month":month,"date":day]
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        manager.POST(
            "http://apibabe.maxtain.com/get_week.php", parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
//                println(response.description)
                self.updateWeek(response as! Dictionary<String,Dictionary<String,String>>!)
            },
            failure: {(operation : AFHTTPRequestOperation!, error : NSError!) in
                println(error.localizedDescription)
            }
        )
    }
    func updateWeek(json : Dictionary<String,Dictionary<String,String>>?){
        updateCityName()
        let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        let year = String(format: "%02d",  components.year)
        let month = String(format: "%02d", components.month)
        let day  = String(format: "%02d", components.day)
        
        st.setObject(json, forKey: Global.weekData)
        st.setValue("\(year)\(month)\(day)\(city_name)", forKey: Global.weekUpdateTime)
        st.synchronize()
        self.weekState = ".Downloaded"
    }
    
    func getSunHour()->(sunrise:Int,presunset:Int,sunset:Int){
        if self.data.cy_sunrise == nil {
            self.data.cy_sunrise = "6:00"
        }
        if self.data.cy_sunset == nil {
            self.data.cy_sunset = "18:00"
        }
        
        let tmp_sunrise:[String] = split(self.data.cy_sunrise!){$0 == ":"}
        let tmp_sunset:[String] = split(self.data.cy_sunset!){$0 == ":"}
        let tmp_sunrise_hour = tmp_sunrise[0].toInt()
        let tmp_sunrise_minute = tmp_sunrise[1].toInt()
        let tmp_sunset_hour = tmp_sunset[0].toInt()
        let tmp_sunset_minute = tmp_sunset[1].toInt()
        
        let sunrise = tmp_sunrise_minute! > 30 ? tmp_sunrise_hour!+1 : tmp_sunrise_hour!
        let presunset = tmp_sunset_minute! > 30 ? tmp_sunset_hour! : tmp_sunset_hour! - 1
        let sunset = presunset + 1
        return (sunrise,presunset,sunset)
//          return (5,17,18)
    }
    
    func nowFilter() -> String!{
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitDay | .CalendarUnitWeekday, fromDate: now)
        
        let hour = String(format: "%02d",  components.hour)
        let month = String(format: "%02d", components.day)
        let week  = String(format: "%02d", components.weekday-1) //need minus 1
        
//                let hour_filter = " and ((ge_hour <= \(hour) and le_hour >= \(hour) and (ge_hour <= le_hour)) or ((ge_hour > le_hour) and ((ge_hour <= \(hour) and \(hour) < 25) or (\(hour) >= 0 and le_hour >= \(hour)))))"
        let sunhour = self.getSunHour()
        let sunrise = sunhour.0
        let presunset = sunhour.1
        let sunset = sunhour.2
        
        let hour_filter = " and  ( ( (ge_hour < 0 and le_hour >= 0) and ( (ge_hour = -10 and \(sunrise) <= le_hour and \(sunrise) <= \(hour) and le_hour > \(hour)  ) or (ge_hour = -10 and \(sunrise) > le_hour and ( (\(sunrise) <= \(hour) and \(hour) < 25)  or  (\(hour) >= 0 and le_hour > \(hour)) ) ) or (ge_hour = -20 and \(sunset) <= le_hour and \(sunset) <= \(hour) and le_hour >= \(hour)  ) or (ge_hour = -20 and \(sunset) > le_hour and ( (\(sunset) <= \(hour) and \(hour) < 25) or  (\(hour) >= 0 and le_hour > \(hour)) ) ) or (ge_hour = -15 and \(presunset) <= le_hour and \(presunset) <= \(hour) and le_hour > \(hour)  ) or (ge_hour = -15 and \(presunset) > le_hour and ( (\(presunset) <= \(hour) and \(hour) < 25) or  (\(hour) >= 0 and le_hour > \(hour)) ) ) )  ) or ( (ge_hour >= 0  and le_hour < 0) and ( (le_hour = -10 and ge_hour <= \(sunrise) and ge_hour <= \(hour) and \(sunrise) > \(hour)  ) or (le_hour = -10 and ge_hour > \(sunrise) and ( (ge_hour <= \(hour) and \(hour) < 25)  or  (\(hour) >= 0 and \(sunrise) > \(hour)) ) ) or (le_hour = -20 and ge_hour <= \(sunset) and ge_hour <= \(hour) and \(sunset) > \(hour)  ) or (le_hour = -20 and ge_hour > \(sunset) and ( (ge_hour <= \(hour) and \(hour) < 25)  or  (\(hour) >= 0 and \(sunset) > \(hour)) ) ) or (le_hour = -15 and ge_hour <= \(presunset) and ge_hour <= \(hour) and \(presunset) > \(hour)  ) or (le_hour = -15 and ge_hour > \(presunset) and ( (ge_hour <= \(hour) and \(hour) < 25)  or  (\(hour) >= 0 and \(presunset) > \(hour)) ) ) ) ) or ( (ge_hour < 0 and le_hour < 0) and ( (ge_hour = -10 and le_hour = -20 and \(sunrise) <= \(hour) and \(sunset) > \(hour)  ) or  (ge_hour = -10 and le_hour = -15 and \(sunrise) <= \(hour) and \(presunset) > \(hour)  ) or (ge_hour = -15 and le_hour = -20 and \(presunset) <= \(hour) and \(sunset) > \(hour)  ) or (ge_hour = -20 and le_hour = -10 and ( (\(sunset) <= \(hour) and \(hour) < 25)  or  (\(hour) >= 0 and \(sunrise) > \(hour))  ) ) or (ge_hour = -15 and le_hour = -10 and ( (\(presunset) <= \(hour) and \(hour) < 25)  or  (\(hour) >= 0 and \(sunrise) > \(hour))  ) ) )  ) or  ( (ge_hour >= 0 and le_hour >= 0)  and  (  (ge_hour <= \(hour) and le_hour > \(hour) and (ge_hour <= le_hour))  or  ((ge_hour > le_hour)  and  ( (ge_hour <= \(hour) and \(hour) < 25)  or  (\(hour) >= 0 and le_hour > \(hour)) ) ) ) ) )"
        
        let week_filter = " and ((ge_week <= \(week) and le_week >= \(week) and (ge_week <= le_week)) or ((ge_week > le_week) and ((ge_week <= \(week) and \(week) <= 7) or (le_week >= \(week) and \(week) >= 0))))"
        let month_filter = " and ((ge_month <= \(month) and le_month >= \(month) and (ge_month <= le_month)) or ((ge_month > le_month) and ((ge_month <= \(month) and \(month) >= 31) or (le_month >=\(month) and \(month) >=0 ))))"
        
        var weather_filter = ""
        if self.getWeather() != nil {
            let weather = self.getWeather()!
            weather_filter = " ((weather = '*') or (weather = '任意天气') or (weather like '%\(weather)%') or ('\(weather)' like '%' || weather || '%'))"
        }
        
        let temp_filter = " and (ge_temp <= \(self.getTemp()!) and le_temp >= \(self.getTemp()!))"
        var aqi_filter = ""
        if let aqii  = self.getAqi() {
            aqi_filter = " and (ge_aqi <= \(aqii) and le_aqi >= \(aqii))"
        }
        
        let filter =  weather_filter + hour_filter + week_filter + month_filter + temp_filter + aqi_filter
        return filter;
        
    }
    
    func getAqi() -> Int? {
        if self.data.cy_realtime_aqi != nil {
            return self.data.cy_realtime_aqi
        }else if self.data.aqi != nil{
            return self.data.aqi
        }else{
            return nil
        }
    }
    
    func getWindLevel() -> String? {
        if self.data.cy_realtime_windlevel != nil {
            return self.data.cy_realtime_windlevel
        }else{
            return self.data.fenglevel
        }
    }
    
    func getHumi() -> String? {
        if self.data.cy_realtime_humidity != nil {
            return self.data.cy_realtime_humidity! + "%"
        }else{
            return self.data.humidity
        }
    }
    
    func getWeather() -> String? {
        if self.data.weather == nil {
            return self.data.today_weather
        }else{
            return self.data.weather
        }
    }
    
    func getTemp() -> String? {
        if self.data.cy_realtime_temperature != nil {
            return self.data.cy_realtime_temperature!.trim()
        }
        if self.data.temp == nil {
            return self.data.rtemp?.trim()
        }else{
            return self.data.temp?.trim()
        }
    }
    
    func save(){
        
        
        
    }
    
}