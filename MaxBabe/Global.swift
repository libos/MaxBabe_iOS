//
//  Global.swift
//  MaxBabe
//
//  Created by Liber on 6/1/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class Global {
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
    
    static let arr_morning = [12,1,2,3,4,5,6,7,8,9,10,11]
    static let arr_afternoon = [24,13,14,15,16,17,18,19,20,21,22,23]
    
    static let WeatherDefault = ["晴","多云","阴","小雨","中雨","大雨","阵雨","雷阵雨","雷阵雨伴有冰雹","暴雨","大暴雨","特大暴雨","雨夹雪","阵雪","小雪","中雪","大雪","暴雪","雾","冻雨","沙尘暴","小雨到中雨","中雨到大雨","大雨到暴雨","暴雨到大暴雨","大暴雨到特大暴雨","小雪到中雪","中雪到大雪","大雪到暴雪","浮尘","扬沙","强沙尘暴","霾"]
    
    static let haze_leve:[String] = ["icon_haze_level1","icon_haze_level2"," icon_haze_level3","icon_haze_level4"," icon_haze_level5","icon_haze_level6"]
}