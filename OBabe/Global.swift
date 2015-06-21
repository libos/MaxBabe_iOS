//
//  Global.swift
//  MaxBabe
//
//  Created by Liber on 6/20/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class Global {
    static let WeatherDefault = ["晴","多云","阴","小雨","中雨","大雨","阵雨","雷阵雨","雷阵雨伴有冰雹","暴雨","大暴雨","特大暴雨","雨夹雪","阵雪","小雪","中雪","大雪","暴雪","雾","冻雨","沙尘暴","小雨到中雨","中雨到大雨","大雨到暴雨","暴雨到大暴雨","大暴雨到特大暴雨","小雪到中雪","中雪到大雪","大雪到暴雪","浮尘","扬沙","强沙尘暴","霾"]
    
    static let WeatherDefaultDayIcon:[String] = ["icon_weather_daytime_clear01","icon_weather_daytime_cloudy01","icon_weather_daytime_cloudy02","icon_weather_daytime_rain05","icon_weather_daytime_rain06","icon_weather_daytime_rain07","icon_weather_daytime_rain01","icon_weather_daytime_rain02","icon_weather_daytime_rain03","icon_weather_daytime_rain08","icon_weather_daytime_rain09","icon_weather_daytime_rain09","icon_weather_daytime_rain04","icon_weather_daytime_snow04","icon_weather_daytime_snow01","icon_weather_daytime_snow02","icon_weather_daytime_snow03","icon_weather_daytime_snow04","icon_weather_daytime_fog02","icon_weather_daytime_rain06","icon_weather_daytime_sandstorm03","icon_weather_daytime_rain06","icon_weather_daytime_rain07","icon_weather_daytime_rain08","icon_weather_daytime_rain09","icon_weather_daytime_rain09","icon_weather_daytime_snow02","icon_weather_daytime_snow03","icon_weather_daytime_snow04","icon_weather_daytime_sandstorm01","icon_weather_daytime_sandstorm02","icon_weather_daytime_sandstorm04","icon_weather_daytime_fog01"]
    static let WeatherDefaultNightIcon:[String] = ["icon_weather_night_clear","icon_weather_night_cloudy","icon_weather_night_cloudy","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_snow","icon_weather_night_snow","icon_weather_night_snow","icon_weather_night_snow","icon_weather_night_snow","icon_weather_night_snow","icon_weather_night_fog","icon_weather_night_rain","icon_weather_daytime_sandstorm03","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_rain","icon_weather_night_snow","icon_weather_night_snow","icon_weather_night_snow","icon_weather_daytime_sandstorm01","icon_weather_daytime_sandstorm02","icon_weather_daytime_sandstorm04","icon_weather_night_fog"]
    
    
    
    static let weather_icon:[String] = ["icon_weather_daytime_clear01","icon_weather_daytime_cloudy01","icon_weather_daytime_cloudy02","icon_weather_daytime_rain01","icon_weather_daytime_rain02","icon_weather_daytime_rain03","icon_weather_daytime_rain04","icon_weather_daytime_rain05","icon_weather_daytime_rain06","icon_weather_daytime_rain07","icon_weather_daytime_rain08","icon_weather_daytime_rain09","icon_weather_daytime_rain09","icon_weather_daytime_snow04","icon_weather_daytime_snow01","icon_weather_daytime_snow02","icon_weather_daytime_snow03","icon_weather_daytime_snow04","icon_weather_daytime_sandstorm01","icon_weather_daytime_sandstorm02","icon_weather_daytime_sandstorm03","icon_weather_daytime_sandstorm04","icon_weather_daytime_fog01","icon_weather_daytime_fog02","icon_weather_daytime_fog01","icon_weather_daytime_fog02","icon_weather_night_clear","icon_weather_night_cloudy","icon_weather_night_rain","icon_weather_night_snow"]
    
    static let weather_icon_text:[String] = ["晴", "多云", "阴","阵雨", "雷阵雨", "冰雹", "雨夹雪", "小雨", "中雨", "大雨", "暴雨", "大暴雨", "特大暴","阵雪", "小雪", "中雪", "大雪", "暴雪", "浮尘", "扬沙", "沙尘暴", "强沙尘", "特强沙", "雾","浓雾", "强浓雾", "晴", "阴", "雨", "雪"]
    
    
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
}