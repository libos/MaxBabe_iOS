//
//  Pics.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class Pics {
    
    struct PicsData {
        
        var background:Background = Background()
        var figure:Figure = Figure()
        var oneword:Oneword = Oneword()

    }
    let data:PicsData!
    let wea:Weather!
    var city:String?
    init(){
        wea = Weather.getInstance
        data = PicsData()

    }
    
    class var getInstance:Pics {
        
        struct Singleton {
            static let instance = Pics()
        }
        return Singleton.instance
    }
    
    func updateSelf()
    {
        var auth:String =  city! +  ". maxtain . mybabe "
        let reso = "xx"
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitDay | .CalendarUnitWeekday, fromDate: now)
        let hour = String(format: "%02d",  components.hour)
        let month = String(format: "%02d", components.day)
        let week  = String(format: "%02d", components.weekday-1)
        
        var aqi = "48"
        
        if wea.getAqi() != nil {
            aqi = "\(wea.getAqi()!)"
        }

        let temp = "\(wea.getTemp()!)"
        let weather = "\(wea.getWeather()!)"
        
        let sunhour = wea.getSunHour()
        let sunrise = sunhour.0
        let presunset = sunhour.1
        let sunset  = sunhour.2
        
        var params:Dictionary = ["id":city!,"auth":auth.md5,"user":"1","hour":hour,"month":month,"week":week,"aqi":aqi,"temp":temp,
            "weather":weather,"reso":reso,"sunrise":"\(sunrise)","sunset":"\(sunset)","presunset":"\(presunset)"]

        println(params.description)
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>

        manager.POST(
            "http://apibabe.maxtain.com/pic_info_iphone.php", parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
//                println(response.description)
                self.updateSuccess(response as? Dictionary!)
            },
            failure: {(operation : AFHTTPRequestOperation!, error : NSError!) in
                println(error.localizedDescription)
            }
        )

    }
    func updateSuccess(json : Dictionary<String,String>!)
    {
        if json != nil && json["state"] != "err"
        {
            data.background.background = json["background"]!
            data.background.bgeaqi = json["bgeaqi"]!
            data.background.bgehour = json["bgehour"]!
            data.background.bgemonth = json["bgemonth"]!
            data.background.bgetemp = json["bgetemp"]!
            data.background.bgeweek = json["bgeweek"]!
            data.background.bid = json["bid"]!
            data.background.bleaqi = json["bleaqi"]!
            data.background.blehour = json["blehour"]!
            data.background.blemonth = json["blemonth"]!
            data.background.bletemp = json["bletemp"]!
            data.background.bleweek = json["bleweek"]!
            data.background.bmd5 = json["bmd5"]!
            data.background.bupdate = json["bupdate"]!
            data.background.bweather = json["bweather"]!
            data.background.save_nofile()
  
            
            
            data.figure.fgeaqi = json["fgeaqi"]!
            data.figure.fgehour = json["fgehour"]!
            data.figure.fgemonth = json["fgemonth"]!
            data.figure.fgetemp = json["fgetemp"]!
            data.figure.fgeweek = json["fgeweek"]!
            data.figure.fid = json["fid"]!
            data.figure.figure = json["figure"]!
            data.figure.fleaqi = json["fleaqi"]!
            data.figure.flehour = json["flehour"]!
            data.figure.flemonth = json["flemonth"]!
            data.figure.fletemp = json["fletemp"]!
            data.figure.fleweek = json["fleweek"]!
            data.figure.fmd5 = json["fmd5"]!
            data.figure.fupdate = json["fupdate"]!
            data.figure.fweather = json["fweather"]!
            data.figure.save_nofile()
            
            
            data.oneword.ogeaqi = json["ogeaqi"]!
            data.oneword.ogehour = json["ogehour"]!
            data.oneword.ogemonth = json["ogemonth"]!
            data.oneword.ogetemp = json["ogetemp"]!
            data.oneword.ogeweek = json["ogeweek"]!
            data.oneword.oid = json["oid"]!
            data.oneword.oleaqi = json["oleaqi"]!
            data.oneword.olehour = json["olehour"]!
            data.oneword.olemonth = json["olemonth"]!
            data.oneword.oletemp = json["oletemp"]!
            data.oneword.oleweek = json["oleweek"]!
            data.oneword.oupdate = json["oupdate"]!
            data.oneword.oweather = json["oweather"]!
            data.oneword.words = json["words"]!
            data.oneword.save()
        }
    }
    
}