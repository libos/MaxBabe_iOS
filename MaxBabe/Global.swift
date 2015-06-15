//
//  Global.swift
//  MaxBabe
//
//  Created by Liber on 6/1/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

final class Global {
    static let create_background_table:String = "CREATE TABLE IF NOT EXISTS `background` ( `id` integer primary key autoincrement , `bid` integer default 0, `filename` varchar(255) NOT NULL, `path` varchar(255) NOT NULL, `md5` varchar(255) NOT NULL, `download` integer default 0, `weather` varchar(255) NOT NULL, `ge_hour` integer default 0, `le_hour` integer default 24, `ge_week` integer default 0, `le_week` integer default 6, `ge_month` integer default 0, `le_month` integer default 31, `ge_temp`integer default -100, `le_temp` integer default 100,  `ge_aqi` integer default 0, `le_aqi` integer default 1000, `created` datetime default (datetime('now','localtime')));";
    static let create_figure_table : String = "CREATE TABLE IF NOT EXISTS `figure` ( `id` integer primary key autoincrement , `fid` integer default 0, `filename` varchar(255) NOT NULL, `path` varchar(255) NOT NULL, `md5` varchar(255) NOT NULL, `download` integer default 0, `weather` varchar(255) NOT NULL, `ge_hour` integer default 0, `le_hour` integer default 24, `ge_week` integer default 0, `le_week` integer default 6, `ge_month` integer default 0, `le_month` integer default 31,  `ge_temp`integer default -100, `le_temp` integer default 100, `ge_aqi` integer default 0, `le_aqi` integer default 1000, `created` datetime default (datetime('now','localtime')));";
    static let create_oneword_table : String = "CREATE TABLE IF NOT EXISTS `oneword` ( `id` integer primary key autoincrement , `oid` integer default 0, `word` text NOT NULL, `weather` varchar(255) NOT NULL, `ge_hour` integer default 0, `le_hour` integer default 24, `ge_week` integer default 0, `le_week` integer default 6, `ge_month` integer default 0, `le_month` integer default 31, `ge_temp`integer default -100, `le_temp` integer default 100, `ge_aqi` integer default 0, `le_aqi` integer default 1000, `created` datetime default (datetime('now','localtime')));";
    static let create_splash_table : String = "CREATE TABLE IF NOT EXISTS `splash` ( `id` integer primary key autoincrement , `filename` varchar(255) NOT NULL, `path` varchar(255) NOT NULL, `md5` varchar(255) NOT NULL, `download` integer default 0, `created` datetime default (datetime('now','localtime')));";
    static let create_city_table : String = "CREATE TABLE IF NOT EXISTS `city` ( `id` integer primary key , `name` varchar(255) NOT NULL, `pinyin` varchar(255) NOT NULL, `level2` varchar(255) NOT NULL, `province` varchar(255) NOT NULL);";
    
    
    
    static let cb_id:String = "choose_background_bid"
    static let cb_filename:String = "choose_background_filename"
    static let cb_path:String = "choose_background_path"
    static let cb_md5:String = "choose_background_md5"
    
    static let cf_id:String = "choose_figure_fid"
    static let cf_filename:String = "choose_figure_filename"
    static let cf_path:String = "choose_figure_path"
    static let cf_md5:String = "choose_figure_md5"
    
    static let co_id:String = "choose_oneword_oid"
    static let co_word:String = "choose_oneword_word"

    static let weatherData:String = "weather_data_storage"
    
    static let dailyUpdateTime:String = "dailyUpdateTime"
    static let dailyData:String = "dailyData"
    static let weekUpdateTime:String = "weekUpdateTime"
    static let weekData:String = "weekData"
    
    static let cityDistrict:String = "city_district_name"
    static let cityCityName:String = "city_city_name"
    static let cityProvince:String = "city_province_name"
    
    
    static let CellCityReuseIdentifier:String = "city_reuse"
    static let CellCityReuse2Identifier:String = "city_reuse2"
    
    static let DefaultCityList:[String] = [ "北京", "上海", "杭州", "深圳", "成都", "香港" ]
    static let DefaultTWCityList:[String] = [ "台北", "高雄", "台南", "台中", "基隆", "嘉义" ]
    
    
    
    static let arr_morning = [12,1,2,3,4,5,6,7,8,9,10,11]
    static let arr_afternoon = [0,13,14,15,16,17,18,19,20,21,22,23]
    
    static let WeatherDefault = ["晴","多云","阴","小雨","中雨","大雨","阵雨","雷阵雨","雷阵雨伴有冰雹","暴雨","大暴雨","特大暴雨","雨夹雪","阵雪","小雪","中雪","大雪","暴雪","雾","冻雨","沙尘暴","小雨到中雨","中雨到大雨","大雨到暴雨","暴雨到大暴雨","大暴雨到特大暴雨","小雪到中雪","中雪到大雪","大雪到暴雪","浮尘","扬沙","强沙尘暴","霾"]

    static let WeatherDefaultDayIcon:[String] = ["icon_home_weather_daytime_clear01","icon_home_weather_daytime_cloudy01","icon_home_weather_daytime_cloudy02","icon_home_weather_daytime_rain05","icon_home_weather_daytime_rain06","icon_home_weather_daytime_rain07","icon_home_weather_daytime_rain01","icon_home_weather_daytime_rain02","icon_home_weather_daytime_rain03","icon_home_weather_daytime_rain08","icon_home_weather_daytime_rain09","icon_home_weather_daytime_rain09","icon_home_weather_daytime_rain04","icon_home_weather_daytime_snow04","icon_home_weather_daytime_snow01","icon_home_weather_daytime_snow02","icon_home_weather_daytime_snow03","icon_home_weather_daytime_snow04","icon_home_weather_daytime_fog02","icon_home_weather_daytime_rain06","icon_home_weather_daytime_sandstorm03","icon_home_weather_daytime_rain06","icon_home_weather_daytime_rain07","icon_home_weather_daytime_rain08","icon_home_weather_daytime_rain09","icon_home_weather_daytime_rain09","icon_home_weather_daytime_snow02","icon_home_weather_daytime_snow03","icon_home_weather_daytime_snow04","icon_home_weather_daytime_sandstorm01","icon_home_weather_daytime_sandstorm02","icon_home_weather_daytime_sandstorm04","icon_home_weather_daytime_fog01"]
    static let WeatherDefaultNightIcon:[String] = ["icon_home_weather_night_clear","icon_home_weather_night_cloudy","icon_home_weather_night_cloudy","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_snow","icon_home_weather_night_snow","icon_home_weather_night_snow","icon_home_weather_night_snow","icon_home_weather_night_snow","icon_home_weather_night_snow","icon_home_weather_daytime_fog02","icon_home_weather_night_rain","icon_home_weather_daytime_sandstorm03","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_rain","icon_home_weather_night_snow","icon_home_weather_night_snow","icon_home_weather_night_snow","icon_home_weather_daytime_sandstorm01","icon_home_weather_daytime_sandstorm02","icon_home_weather_daytime_sandstorm04","icon_home_weather_daytime_fog01"]
    
    static let haze_leve:[String] = ["icon_haze_level1","icon_haze_level2"," icon_haze_level3","icon_haze_level4"," icon_haze_level5","icon_haze_level6"]
    
    static let weather_icon_home:[String] = ["icon_home_weather_daytime_clear01","icon_home_weather_daytime_cloudy01","icon_home_weather_daytime_cloudy02","icon_home_weather_daytime_rain01","icon_home_weather_daytime_rain02","icon_home_weather_daytime_rain03","icon_home_weather_daytime_rain04","icon_home_weather_daytime_rain05","icon_home_weather_daytime_rain06","icon_home_weather_daytime_rain07","icon_home_weather_daytime_rain08","icon_home_weather_daytime_rain09","icon_home_weather_daytime_rain09","icon_home_weather_daytime_snow04","icon_home_weather_daytime_snow01","icon_home_weather_daytime_snow02","icon_home_weather_daytime_snow03","icon_home_weather_daytime_snow04","icon_home_weather_daytime_sandstorm01","icon_home_weather_daytime_sandstorm02","icon_home_weather_daytime_sandstorm03","icon_home_weather_daytime_sandstorm04","icon_home_weather_daytime_fog01","icon_home_weather_daytime_fog02","icon_home_weather_daytime_fog01","icon_home_weather_daytime_fog02","icon_home_weather_night_clear","icon_home_weather_night_cloudy","icon_home_weather_night_rain","icon_home_weather_night_snow"]
    
    static let weather_icon_text:[String] = ["晴", "多云", "阴","阵雨", "雷阵雨", "冰雹", "雨夹雪", "小雨", "中雨", "大雨", "暴雨", "大暴雨", "特大暴","阵雪", "小雪", "中雪", "大雪", "暴雪", "浮尘", "扬沙", "沙尘暴", "强沙尘", "特强沙", "雾","浓雾", "强浓雾", "晴", "阴", "雨", "雪"]
    
    static let ACCOUNT_EMAIL =  "ACCOUNT_EMAIL"
    static let ACCOUNT_PHONE =  "ACCOUNT_PHONE"
    static let ACCOUNT_NICKNAME =  "ACCOUNT_NICKNAME"
    static let ACCOUNT_SEX =  "ACCOUNT_SEX"
    static let ACCOUNT_PASSWORD =  "ACCOUNT_PASSWORD"
    
    static let noti_wicon_night_start_idx = 26
    static let noti_wicon_cloudy_up = 1
    static let noti_wicon_cloudy_down = 2
    static let noti_wicon_rain_up = 3
    static let noti_wicon_rain_down = 12
    static let noti_wicon_snow_up = 13
    static let noti_wicon_snow_down = 17
    static let noti_icon_night_clear_idx = 26
    static let noti_icon_night_cloudy_idx = 27
    static let noti_icon_night_rain_idx = 28
    static let noti_icon_night_snow_idx = 29
    static let noti_icon_daytime_snow_idx = 13
    
    
    static let SETTING_SWITCH_PUSH_NOTICE = "SETTING_SWITCH_PUSH_NOTICE"
    static let SETTING_SWITCH_AUTOUPDATE = "SETTING_SWITCH_AUTOUPDATE"
    static let SETTING_SWITCH_ONLYWIFI = "SETTING_SWITCH_ONLYWIFI"
    static let SETTING_SWITCH_NOTIFICATION = "SETTING_SWITCH_NOTIFICATION"
    static let SETTING_SWITCH_GPS_LOCATING = "SETTING_SWITCH_GPS_LOCATING"
    static let SETTING_SWITCH_NEGATIVE = "SETTING_SWITCH_NEGATIVE"
    
    static let THE_WORD = "THE_WORD_CHOOSED"
    static let THE_BACKGROUND = "THE_BACKGROUND_CHOOSED"
    static let THE_FIGURE = "THE_FIGURE_CHOOSED"
    
    static let SHARE_CARD_WIDTH_RATION:CGFloat = 0.82
    static let SHARE_CARD_HEIGHT_RATION:CGFloat = 0.66
    
    static func isValidEmail(testStr:String) -> Bool {
        if  testStr.stringByTrimmingLeadingAndTrailingWhitespace() == "" {
            return false
        }
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr.stringByTrimmingLeadingAndTrailingWhitespace())
    }
    
    static func isValidPhoneNumber(value: String) -> Bool {
        var charcter  = NSCharacterSet(charactersInString: "0123456789").invertedSet
        var filtered:NSString!
        var inputString:NSArray = value.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        return  value == filtered
    }

}