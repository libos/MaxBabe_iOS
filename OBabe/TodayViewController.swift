//
//  TodayViewController.swift
//  Widget
//
//  Created by Liber on 6/4/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
   @IBOutlet weak var ivNowIcon: UIImageView!
   @IBOutlet weak var lbNowWeather: UILabel!
   
   @IBOutlet weak var lbLocation: UILabel!
   @IBOutlet weak var lbUpdateTime: UILabel!
   
   @IBOutlet weak var lbNowTemp: UILabel!
   @IBOutlet weak var lbTempRange: UILabel!
   
   @IBOutlet weak var lbTime1: UILabel!
   @IBOutlet weak var lbTempTime1: UILabel!
   @IBOutlet weak var ivTime1Icon: UIImageView!
   
   @IBOutlet weak var lbTime2: UILabel!
   @IBOutlet weak var lbTempTime2: UILabel!
   @IBOutlet weak var ivTime2Icon: UIImageView!
   
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
   
   let globalAfternoonTemp = "globalAfternoonTemp"
   let globalAfternoonWeather = "globalAfternoonWeather"
   let globalPrenightTemp = "globalPrenightTemp"
   let globalPrenightWeather = "globalPrenightWeather"
   let globalTonightTemp = "globalTonightTemp"
   let globalTonightWeather = "globalTonightWeather"
   
   let globalcy_temp_max = "global_cy_temp_max"
   let globalcy_temp_avg = "global_cy_temp_avg"
   let globalcy_temp_min = "global_cy_temp_min"
   let globalcy_realtime_temperature = "global_cy_realtime_temperature"
   let globalcy_temp_14 = "global_cy_temp_14"
   let globalcy_temp_18 = "global_cy_temp_18"
   let globalcy_temp_21 = "global_cy_temp_21"
   
   
   
   var city_name:String? = "北京"
   var city_display_name:String? = "北京"
   var district_name:String?
   
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
   var afternoon_temp : String?
   var afternoon_weather : String?
   var prenight_temp : String?
   var prenight_weather : String?
   var tonight_temp : String?
   var tonight_weather : String?
   
   var cy_temp_max : String?
   var cy_temp_avg : String?
   var cy_temp_min : String?
   var cy_realtime_temperature : String?
   var cy_temp_14 : String?
   var cy_temp_18 : String?
   var cy_temp_21 : String?
   
   let cityDistrict:String = "city_district_name"
   let cityCityName:String = "city_city_name"
   let cityCityDisplayName:String = "city_city_display_name"
   let cityProvince:String = "city_province_name"
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.preferredContentSize = CGSizeMake(320,150)
      var tap = UITapGestureRecognizer(target: self, action: "openApp:")
      self.view.addGestureRecognizer(tap)
      
      self.updateFromAppGroup()
      //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDefaultsDidChange:", name: NSUserDefaultsDidChangeNotification, object: nil)
      
      //
   }
   
   @IBAction func openApp(sender: AnyObject) {
      var customURL = NSURL(string: "maxbabe://")
      self.extensionContext?.openURL(customURL!, completionHandler: nil)
   }
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      
   }
   
   func updateFromAppGroup(){
      var st = NSUserDefaults(suiteName: "group.maxtain.MaxBabe")
      city_name = st?.stringForKey(cityCityName)
      city_display_name = st?.stringForKey(cityCityDisplayName)
      district_name = st?.stringForKey(cityDistrict)
      
      if let tmp = getCityName() {
         lbLocation.text = tmp
      }
      let now = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
      
      //        var timeeee = st?.stringForKey(globalUpdateTimeFlag)
      //        if timeeee == "\(components.year)\(components.month)\(components.day)\(self.city_name!)" {
      self.temp = st?.stringForKey(globalWeatherTemp)
      self.weather = st?.stringForKey(globalWeatherWeather)
      self.rtemp = st?.stringForKey(globalWeatherRTemp)
      self.rweather = st?.stringForKey(globalWeatherRWeather)
      self.today_weather = st?.stringForKey(globalTodayWeather)
      self.day_temp = st?.stringForKey(globalDayTemp)
      self.day_weather = st?.stringForKey(globalDayWeather)
      self.night_temp = st?.stringForKey(globalNightTemp)
      self.night_weather = st?.stringForKey(globalNightWeahter)
      self.next_day_temp = st?.stringForKey(globalNextDayTemp)
      self.next_day_weather = st?.stringForKey(globalNextDayWeather)
      self.next_night_temp = st?.stringForKey(globalNextNightTemp)
      self.next_night_weather = st?.stringForKey(globalNextNightWeather)
      self.afternoon_temp = st?.stringForKey(globalAfternoonTemp)
      self.afternoon_weather = st?.stringForKey(globalAfternoonWeather)
      self.prenight_temp = st?.stringForKey(globalPrenightTemp)
      self.prenight_weather = st?.stringForKey(globalPrenightWeather)
      self.tonight_temp = st?.stringForKey(globalTonightTemp)
      self.tonight_weather = st?.stringForKey(globalTonightWeather)
      self.cy_temp_max = st?.stringForKey(globalcy_temp_max)
      self.cy_temp_avg = st?.stringForKey(globalcy_temp_avg)
      self.cy_temp_min = st?.stringForKey(globalcy_temp_min)
      self.cy_realtime_temperature = st?.stringForKey(globalcy_realtime_temperature)
      self.cy_temp_14 = st?.stringForKey(globalcy_temp_14)
      self.cy_temp_18 = st?.stringForKey(globalcy_temp_18)
      self.cy_temp_21 = st?.stringForKey(globalcy_temp_21)
      if self.weather != nil && self.cy_temp_max != nil{
         updateUI()
      }
      //        }
      updateWeather()
   }
   
   
   func getCityName() -> String?{
      if district_name != nil{
         return district_name
      }else{
         return city_display_name
      }
   }
   
   func updateWeather(){
      if self.city_name == nil {
         return
      }
      var city_param = self.city_name!.cleanCity()
      var auth : String =  city_param +  ". maxtain .widget. mybabe "
      let now = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components(.CalendarUnitHour | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
      
      let hour = String(format: "%02d",  components.hour)
      let month = String(format: "%02d", components.month)
      let day  = String(format: "%02d", components.day)
      
      var params:Dictionary = ["id":city_param,"auth":auth.md5,"hour":hour,"month":month,"day":day]
      
      
      
      request(.GET, "http://apibabe.maxtain.com/widget.php", parameters: params).responseJSON(options: NSJSONReadingOptions()) { (_, _, json:AnyObject?, _) -> Void in
         println(json)
         self.updateSuccess(json as! NSDictionary)
      }
      
   }
   
   
   func updateSuccess(json : NSDictionary!){
      if (json["state"] as? String != "err") {
         self.temp = json["temp"] as? String
         self.weather = json["weather"] as? String
         self.rtemp = json["rtemp"] as? String
         self.rweather = json["rweather"] as? String
         //            self.today_weather = json["today_weather"] as? String
         self.day_weather = json["day_weather"] as? String
         self.night_weather = json["night_weather"] as? String
         self.day_temp = json["day_temp"] as? String
         self.night_temp = json["night_temp"] as? String
         
         self.afternoon_temp = json["afternoon_temp"] as? String
         self.afternoon_weather = json["afternoon_weather"] as? String
         self.prenight_temp = json["prenight_temp"] as? String
         self.prenight_weather = json["prenight_weather"] as? String
         self.tonight_temp = json["tonight_temp"] as? String
         self.tonight_weather = json["tonight_weather"] as? String
         
         self.next_day_weather = json["tomo_morning_weather"] as? String
         self.next_night_weather = json["tomo_night_weather"] as? String
         self.next_day_temp = json["tomo_morning_temp"] as? String
         self.next_night_temp = json["tomo_night_temp"] as? String
         
         self.cy_temp_max = json["cy_temp_max"] as? String
         self.cy_temp_avg = json["cy_temp_avg"] as? String
         self.cy_temp_min = json["cy_temp_min"] as? String
         self.cy_realtime_temperature = json["cy_realtime_temperature"] as? String
         self.cy_temp_14 = json["cy_temp_14"] as? String
         self.cy_temp_18 = json["cy_temp_18"] as? String
         self.cy_temp_21 = json["cy_temp_21"] as? String
         
         var st = NSUserDefaults(suiteName: "group.maxtain.MaxBabe")
         let now = NSDate()
         let calendar = NSCalendar.currentCalendar()
         let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
         
         st?.setValue("\(components.year)\(components.month)\(components.day)\(self.city_name!)", forKey: globalUpdateTimeFlag)
         st?.setValue(self.temp, forKey: globalWeatherTemp)
         st?.setValue(self.weather, forKey: globalWeatherWeather)
         st?.setValue(self.rtemp, forKey: globalWeatherRTemp)
         st?.setValue(self.rweather, forKey: globalWeatherRWeather)
         st?.setValue(self.day_temp, forKey: globalDayTemp)
         st?.setValue(self.day_weather, forKey: globalDayWeather)
         st?.setValue(self.night_temp, forKey: globalNightTemp)
         st?.setValue(self.night_weather, forKey: globalNightWeahter)
         
         st?.setValue(self.afternoon_temp, forKey: globalAfternoonTemp)
         st?.setValue(self.afternoon_weather, forKey: globalAfternoonWeather)
         st?.setValue(self.prenight_temp, forKey: globalPrenightTemp)
         st?.setValue(self.prenight_weather, forKey: globalPrenightWeather)
         st?.setValue(self.tonight_temp, forKey: globalTonightTemp)
         st?.setValue(self.tonight_weather, forKey: globalTonightWeather)
         
         st?.setValue(self.next_day_temp, forKey: globalNextDayTemp)
         st?.setValue(self.next_day_weather, forKey: globalNextDayWeather)
         st?.setValue(self.next_night_temp, forKey: globalNextNightTemp)
         st?.setValue(self.next_night_weather, forKey: globalNextNightWeather)
         st?.setValue(self.cy_temp_max, forKey: globalcy_temp_max)
         st?.setValue(self.cy_temp_avg, forKey: globalcy_temp_avg)
         st?.setValue(self.cy_temp_min, forKey: globalcy_temp_min)
         st?.setValue(self.cy_realtime_temperature, forKey: globalcy_realtime_temperature)
         st?.setValue(self.cy_temp_14, forKey: globalcy_temp_14)
         st?.setValue(self.cy_temp_18, forKey: globalcy_temp_18)
         st?.setValue(self.cy_temp_21, forKey: globalcy_temp_21)
         st?.synchronize()
         updateUI()
      }
   }
   
   func updateUI(){
      lbNowTemp.text = getTemp()! + "°"
      lbNowWeather.text = getWeather()
      ivNowIcon.image = getWeatherIcon(lbNowWeather.text!)
      changePublishTime()
      lbTempRange.text = self.cy_temp_max!.trim() + "/" + self.cy_temp_min!.trim() + "°"
      //        1.早上的時候，那兩個位置顯示的是下午，夜晚
      //        2.下午的時候，那兩個位置顯示的是傍晚，夜晚
      //        3.傍晚的時候，那兩個位置顯示的是夜晚，明早
      //        4.夜晚的時候，那兩個位置顯示的是明早，明晚
      let now = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components(.CalendarUnitHour, fromDate: now)
      let hour =  components.hour
      if hour >= 6 && hour < 12 {
         lbTime1.text = "下午"
         lbTime2.text = "夜晚"
         lbTempTime1.text = self.get_afternoon_temp() + "°"
         lbTempTime2.text = self.get_tonight_temp() + "°"
         ivTime1Icon.image = getWeatherIcon(self.afternoon_weather!)
         ivTime2Icon.image = getWeatherIcon(self.tonight_weather!)
      }else if hour >= 12 && hour < 17 {
         lbTime1.text = "傍晚"
         lbTime2.text = "夜晚"
         lbTempTime1.text = self.get_prenight_temp() + "°"
         lbTempTime2.text = self.get_tonight_temp() + "°"
         ivTime1Icon.image = getWeatherIcon(self.prenight_weather!)
         ivTime2Icon.image = getWeatherIcon(self.tonight_weather!)
      }else if hour >= 17 && hour < 19 {
         lbTime1.text = "夜晚"
         lbTime2.text = "明早"
         lbTempTime1.text = self.get_tonight_temp() + "°"
         lbTempTime2.text = self.next_day_temp!.trim() + "°"
         ivTime1Icon.image = getWeatherIcon(self.tonight_weather!)
         ivTime2Icon.image = getWeatherIcon(self.next_day_weather!)
      }else{
         lbTime1.text = "明早"
         lbTime2.text = "明晚"
         lbTempTime1.text = self.next_day_temp!.trim() + "°"
         lbTempTime2.text = self.next_night_temp!.trim() + "°"
         ivTime1Icon.image = getWeatherIcon(self.next_day_weather!)
         ivTime2Icon.image = getWeatherIcon(self.next_night_weather!)
      }
   }
   func getWeather() -> String? {
      if self.today_weather != nil {
         return self.today_weather!
      }else if self.weather != nil{
         return self.weather!
      }else{
         return "晴"
      }
   }
   func get_afternoon_temp() -> String {
      if self.cy_temp_14 != nil {
         return self.cy_temp_14!.trim()
      }else{
         return self.tonight_temp!.trim()
      }
   }
   func get_prenight_temp() -> String {
      if self.cy_temp_18 != nil {
         return self.cy_temp_18!.trim()
      }else{
         return self.prenight_temp!.trim()
      }
   }
   func get_tonight_temp() -> String {
      if self.cy_temp_21 != nil {
         return self.cy_temp_21!.trim()
      }else{
         return self.tonight_temp!.trim()
      }
   }
   
   func getTemp() -> String? {
      if self.cy_realtime_temperature != nil {
         return self.cy_realtime_temperature!
      }
      if self.rtemp != nil {
         return self.rtemp!
      }else if self.temp != nil{
         return self.temp!
      }else{
         return "28"
      }
   }
   func userDefaultsDidChange(noti:NSNotification){
      self.updateFromAppGroup()
   }
   
   // MARK: - Change Publis Timer
   func changePublishTime(){
      let now = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components(NSCalendarUnit.CalendarUnitMinute, fromDate: now)
      var minutes = components.minute
      if (minutes >= 30) {
         minutes = minutes - 30
      }
      var tip:String
      if (minutes <= 3) {
         tip = "（刚刚更新）"    //res.getString(R.string.just_now);
      } else {
         tip = "（\(minutes)分钟前发布）"//res.getString(R.string.minutes_ago);
      }
      lbUpdateTime.text = tip;
   }
   
   func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
      completionHandler(NCUpdateResult.NewData)
   }
   
   func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
      return UIEdgeInsetsZero
   }
}


extension TodayViewController{
   func getWeatherIcon(name:String)->UIImage?{
      var idx = find(Global.WeatherDefault, name)
      let now = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components(.CalendarUnitHour , fromDate: now)
      
      let hour = components.hour
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
         return UIImage(named: Global.weather_icon[Global.noti_icon_night_clear_idx])
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
      
      return UIImage(named: Global.weather_icon[w_idx])
   }
   
}
extension String{
   var md5 : String! {
      let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
      let strlen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
      let digestlen = Int(CC_MD5_DIGEST_LENGTH)
      
      let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestlen)
      CC_MD5(str!,strlen,result)
      
      var hash = NSMutableString()
      
      for i in  0..<digestlen {
         hash.appendFormat("%02x", result[i])
      }
      result.dealloc(digestlen)
      
      return String(format: hash as String)
   }
   
   func cleanCity() -> String{
      var ret_name:String = self
      for wd in ["市","市辖区","自治区", "自治州", "地区", "特别行政区"] {
         ret_name = ret_name.stringByReplacingOccurrencesOfString(wd, withString: "")
      }
      return ret_name
   }
   func trim() ->String{
      return self.stringByTrimmingLeadingAndTrailingWhitespace().stringByReplacingOccurrencesOfString("\r", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
   }
   func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
      let leadingAndTrailingWhitespacePattern = "(?:^\\s+)|(?:\\s+$)"
      
      if let regex = NSRegularExpression(pattern: leadingAndTrailingWhitespacePattern, options: .CaseInsensitive, error: nil) {
         let range = NSMakeRange(0, count(self))
         let trimmedString = regex.stringByReplacingMatchesInString(self, options: .ReportProgress, range:range, withTemplate:"$1")
         
         return trimmedString
      } else {
         return self
      }
   }
}