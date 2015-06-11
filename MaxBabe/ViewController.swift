//
//  ViewController.swift
//  MaxBabe
//
//  Created by Liber on 5/26/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit
import Darwin
import Foundation

class ViewController: UIViewController,UIScrollViewDelegate{
    
    
    @IBOutlet var rootView: UIView!
    
    @IBOutlet weak var mBackground: UIImageView!
    @IBOutlet weak var mFigure: UIImageView!
    
    @IBOutlet weak var lbWord: UILabel!
    
    @IBOutlet weak var tvWeather: UILabel!
    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var mTemp: UILabel!
    @IBOutlet weak var lbWind: UILabel!
    @IBOutlet weak var lbHumi: UILabel!
    
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbUpdateTime: UILabel!
    
    @IBOutlet weak var lbTomoWeather: UILabel!
    @IBOutlet weak var lbTomoHighTemp: UILabel!
    @IBOutlet weak var lbTomoLowTemp: UILabel!
    
    @IBOutlet weak var ivHazeEnd: UIImageView!
    @IBOutlet weak var ivHazeBegin: UIImageView!
    @IBOutlet weak var ivWind: UIImageView!
    @IBOutlet weak var ivWet: UIImageView!
    
    @IBOutlet weak var openCityBtn: UIButton!
    @IBOutlet weak var openShareBtn: UIButton!
    @IBOutlet weak var openSettingBtn: UIButton!
    
    
    @IBOutlet weak var ivAqi: UIImageView!
    @IBOutlet weak var lbAqi: UILabel!


    var screenHeight:CGFloat!
    var screenWidth:CGFloat!
    //    var blurredImageView:UIImageView!
    //    var blurredFigureView:UIImageView!
    var detailView:UIScrollView!
    var refreshControl:UIRefreshControl!
    let center:Center = Center.getInstance
    let weather:Weather = Weather.getInstance
    var page2:UIView!
    
    // clock
    var layer_center:UIView!
    var layer_number:UIView!
    var layer_number_back:UIView!
    var layer_dots:UIView!
    var layer_icons:UIView!
    var clock_layers:[UIView]!
    
    var icon_weathers:[UIImageView]! = []
    var lbNumber:[UILabel]! = []
    var ivLabelBackground:UIImageView!
    var ivDots:[UIImageView]! = []

    var lbTodayWeather:UILabel!
    var ivWeatherIcon:UIImageView!
    
    // waves
    var layer_wave:UIView!
    var layer_highWave:UIView!
    var layer_lowWave:UIView!
    var layer_waveDots:UIView!
    var layer_bar:UIView!
    var layer_waveTop:UIView!
    var layer_highLabel:UIView!
    var layer_lowLabel:UIView!
    
    var ivWaveHighDots:[UIImageView]! = []
    var ivWaveLowDots:[UIImageView]! = []
    var lybars:[UIView]! = []
    var lbHighNumber:[UILabel]! = []
    var lbLowNumber:[UILabel]! = []
    var lbBarTime:[UILabel]! = []
    var ivBarWeather:[UIImageView]! = []
    
    var highData:[Int] = []
    var lowData:[Int] = []
    
    var dailyData:[Int:(Int,String)]?
    var weekData: Dictionary<Int, (Int, Int, String)>?

    var city = City.getInstance

    var isClockSetup:Bool = false
    var isChartSetup:Bool = false
    var isViewAppeared:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if city.city_name != nil {
            if city.district != nil && city.district != "" {
                lbLocation.text = city.district
            }else if city.city_name != nil{
                lbLocation.text = city.city_name
            }
        }
        
        city.addObserver(self, forKeyPath: "city_name", options: NSKeyValueObservingOptions.New, context: nil)
        weather.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.New, context: nil)
        weather.addObserver(self, forKeyPath: "dailyState", options: NSKeyValueObservingOptions.New, context: nil)
        weather.addObserver(self, forKeyPath: "weekState", options: NSKeyValueObservingOptions.New, context: nil)

        // TODO
        self.screenHeight =  UIScreen.mainScreen().bounds.size.height
        self.screenWidth = UIScreen.mainScreen().bounds.size.width
        
        let aTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(200.0, target: self, selector: "changePublishTime:", userInfo: nil, repeats: true)
        aTimer.fire()
//        let aTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
//        aTimer.fire()

//        let xxx:UIView = UIView(frame: self.view.frame)
//        xxx.drawRect(self.view.layer.renderInContext(UIGraphicsGetCurrentContext()))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "testRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        

        self.detailView = UIScrollView(frame: self.view.bounds)
        self.detailView.contentSize = CGSizeMake(self.detailView.frame.size.width,self.detailView.frame.size.height*2)
        self.detailView.backgroundColor = UIColor.clearColor()//UIColor(white: 0, alpha: 0.8)
        self.detailView.delegate = self
        self.detailView.pagingEnabled = true
        self.detailView.scrollEnabled = true
//        self.detailView.userInteractionEnabled = true
        self.detailView.addSubview(self.refreshControl)
        
        
        self.view.addSubview(self.detailView)
        
        let nextFrame = UIScreen.mainScreen().bounds
//        let inset:CGFloat = 20
        
        self.page2 = UIView(frame: CGRect(x: 0, y: screenHeight , width: self.view.bounds.size.width, height: screenHeight))
        self.page2.backgroundColor = UIColor(rgba: "#02a8f3")
//        self.page2.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.detailView.addSubview(page2)
        
        layer_center = UIView()
        layer_center.setTranslatesAutoresizingMaskIntoConstraints(false)

        ivWeatherIcon = UIImageView(image: UIImage(named: "icon_home_weather_daytime_clear01"))
        ivWeatherIcon.setTranslatesAutoresizingMaskIntoConstraints(false)

        lbTodayWeather = UILabel()
        lbTodayWeather.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var strW = "晴"
        let oRange = NSMakeRange(0, count(strW))
        var strWeather = NSMutableAttributedString(string: strW)
        strWeather.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        strWeather.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10), range: oRange)
        lbTodayWeather.layer.shadowColor = UIColor.blackColor().CGColor
        lbTodayWeather.layer.shadowRadius = 6.0
        lbTodayWeather.layer.shadowOpacity = 0.5
        lbTodayWeather.layer.shadowOffset = CGSizeMake(0, 0)
        lbTodayWeather.attributedText  = strWeather
        
        
        layer_number = UIView()
        layer_number.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layer_number_back = UIView()
        layer_number_back.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layer_dots = UIView()
        layer_dots.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layer_icons = UIView()
        layer_icons.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        layer_center.addSubview(ivWeatherIcon)
        layer_center.addSubview(lbTodayWeather)
        
        layer_center.addSubview(layer_number_back)
        layer_center.addSubview(layer_number)
        layer_center.addSubview(layer_dots)
        layer_center.addSubview(layer_icons)
        
        self.page2.addSubview(layer_center)
        
        

        layer_wave = UIView()
        layer_wave.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.layer_highWave = UIView()
        self.layer_highWave.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layer_lowWave = UIView()
        self.layer_lowWave.setTranslatesAutoresizingMaskIntoConstraints(false)
        

        self.layer_waveDots = UIView()
        self.layer_highLabel = UIView()
        self.layer_lowLabel = UIView()
        self.layer_bar = UIView()
        self.layer_waveTop = UIView()
        
        self.layer_bar.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layer_waveTop.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layer_waveDots.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layer_highLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.layer_lowLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.layer_wave.addSubview(layer_bar)
        self.layer_wave.addSubview(layer_highWave)
        self.layer_wave.addSubview(layer_lowWave)
        self.layer_wave.addSubview(layer_waveTop)
        self.layer_wave.addSubview(layer_waveDots)
        self.layer_wave.addSubview(layer_highLabel)
        self.layer_wave.addSubview(layer_lowLabel)
        
        self.page2.addSubview(layer_wave)

        self.view.bringSubviewToFront(openCityBtn)
        self.view.bringSubviewToFront(openShareBtn)
        self.view.bringSubviewToFront(openSettingBtn)
        if city.city_name != nil{
            retriveData()
        }

        constraintSetup()
        
    }
    

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "city_name"{
            if city.district != nil && city.district != "" {
                lbLocation.text = city.district
            }else if city.city_name != nil{
                lbLocation.text = city.city_name
            }
            city.removeObserver(self, forKeyPath: "city_name")
            retriveData()
        }else if keyPath == "state" {
            if weather.state == ".Stored"{
                self.updateView()
                if !isChartSetup &&  isViewAppeared {
                    self.weather.getWeek()
                }
            }
        }else if keyPath == "dailyState" {
            if weather.dailyState == ".DailyDone" {
                self.dailyData = self.weather.dailyData
                self.clockSetup()
            }else if weather.dailyState == ".Downloaded" {
                self.dailyData = self.weather.getDailyNoStateChange()
                self.clockSetup()
            }
        }else if keyPath == "weekState" {
            if weather.state == ".Stored" {
                if weather.weekState == ".WeekDone" {
                    self.weekData = self.weather.weekData
                    self.lineChartSetup()
                }else if weather.weekState == ".Downloaded"{
                    self.weekData = self.weather.getWeekNoStateChange()
                    self.lineChartSetup()
                }
            }
        }
    }
    
    func retriveData(){
        if city.city_name == nil {
            return
        }
        self.weather.city_name = city.cleanCityName()
        if weather.state != ".Stored" {
            self.weather.updateSelf()
        }else{
            self.updateView()
        }
        if weather.dailyState != ".DailyDone" {
            self.weather.getDaily()
        }else{
            self.dailyData = self.weather.dailyData
            self.clockSetup()
        }
        if !isChartSetup &&  isViewAppeared {
            if weather.state == ".Stored" && weather.weekState != ".WeekDone" {
                self.weather.getWeek()
                
            }else if weather.state == ".Stored" && weather.weekState == ".WeekDone"{
                self.weekData = self.weather.weekData
                self.lineChartSetup()
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isViewAppeared = true
        if city.city_name != nil {
            if weather.weekState == ".WeekDone" {
                self.weekData = self.weather.weekData
                self.lineChartSetup()
                //            center.waitForWeekWeather(updateViews: { () -> () in
                //                self.weekData = self.weather.weekData
                //                self.lineChartSetup()
                //            })
            }else if weather.weekState == ".Downloaded"{
                self.weekData = self.weather.getWeek()
                self.lineChartSetup()
            }else{
                self.weather.getWeek()
            }
        }
//        let bTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: "timerWeekDataDownloadFired:", userInfo: nil, repeats: true)
//        bTimer.fire()
    }
    
    func testRefresh(refreshC:UIRefreshControl){
        //        refreshC.attributedTitle = NSAttributedString(string: "Refreshing data...")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            //            NSThread.sleepForTimeInterval(3)
            
            dispatch_async(dispatch_get_main_queue(),{
                self.center.start(updateViews: {
                    self.updateView()
                    refreshC.endRefreshing()
                })
            })
        })
    }
    
    func timerFired(timer:NSTimer){
        self.center.start(updateViews: {
            self.updateView()
        })

    }
    func timerWeekDataDownloadFired(timer:NSTimer){
        if weather.weekState == ".WeekDone" {
            self.weekData = self.weather.weekData
            self.lineChartSetup()
//            center.waitForWeekWeather(updateViews: { () -> () in
//                self.weekData = self.weather.weekData
//                self.lineChartSetup()
//            })
        }else if weather.weekState == ".Downloaded"{
            self.weekData = self.weather.getWeek()
            self.lineChartSetup()
        }else{
            self.weather.getWeek()
        }
    }
    
    func updateView(){
//        City.getInstance.updateLoction()
        if weather.getTemp() == nil {
            self.mTemp.text = "0°"
        }else{
            self.mTemp.text = "\(weather.getTemp()!)°"
        }
        if weather.getWeather() == nil {
            self.tvWeather.text = "晴"
        }else{
            let wwwww = weather.getWeather()!
            self.tvWeather.text = "\(wwwww)°"
            self.ivWeather.image = center.getWeatherIcon(wwwww)
        }
        
        
        //Todo set icon
        //
        if let aqi = weather.data.aqi {
            if aqi != 0{
                self.ivHazeEnd.hidden = false
                self.ivHazeBegin.hidden = false
                self.ivAqi.hidden = false
                self.lbAqi.hidden = false
                var aqi_msg: String = "48 超赞"
                var haze_level = 0
                // Log.e("err", data.toString())
                if (aqi <= 50) {
                    aqi_msg = " \(aqi) 超赞"
                    haze_level = 0
                } else if (aqi > 50 && aqi <= 100) {
                    aqi_msg = " \(aqi) 还不错"
                    haze_level = 1
                } else if (aqi > 100 && aqi <= 150) {
                    aqi_msg = " \(aqi) 有点差哦"
                    haze_level = 2
                } else if (aqi > 150 && aqi <= 200) {
                    aqi_msg = " \(aqi) 蛮差的"
                    haze_level = 3
                } else if (aqi > 200 && aqi <= 300) {
                    aqi_msg = " \(aqi) 别出门了"
                    haze_level = 4
                } else if (aqi > 300) {
                    aqi_msg = " \(aqi) 已爆表"
                    haze_level = 5
                }
                self.ivAqi.image = UIImage(named: Global.haze_leve[haze_level])
                self.lbAqi.text = aqi_msg
                self.lbAqi.textAlignment = NSTextAlignment.Center
            }
        }else{
            self.ivHazeEnd.hidden = true
            self.ivHazeBegin.hidden = true
            self.ivAqi.hidden = true
            self.lbAqi.hidden = true
        }
        
        self.lbTomoWeather.text = "明天，\(weather.data.tomo_weather!)"
        if let tomoTemp = weather.data.tomo_temp {
            let ttemp:[String] = split(tomoTemp.stringByReplacingOccurrencesOfString("℃", withString: "")){$0 == "~"}
            var high:Int
            var low:Int
            if(ttemp[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt() > ttemp[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()){
                high = ttemp[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
                low = ttemp[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
            }else{
                high = ttemp[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
                low = ttemp[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
            }
            self.lbTomoHighTemp.text = "\(high)"
            self.lbTomoLowTemp.text = "\(low)"
        }else{
            let night = weather.data.next_night_temp?.stringByReplacingOccurrencesOfString("℃", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let day = weather.data.next_day_temp?.stringByReplacingOccurrencesOfString("℃", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if (night != nil && day != nil)  {
                var high:Int
                var low:Int
                if(night!.toInt() > day!.toInt()){
                    high = night!.toInt()!
                    low = day!.toInt()!
                }else{
                    high = day!.toInt()!
                    low = night!.toInt()!
                }
                self.lbTomoHighTemp.text = "\(high)"
                self.lbTomoLowTemp.text = "\(low)"
            }
        }
        let humi = weather.data.humidity
        if humi != nil && humi != "" {
            self.lbHumi.text = humi
            self.ivWet.hidden = false
            self.lbHumi.hidden = false
        }else{
//            self.ivWet
            self.ivWet.hidden = true
            self.lbHumi.hidden = true
        }
        let wind = weather.data.fenglevel
        if wind != nil && wind != ""  {
            self.lbWind.text = getWindDisplay(wind!)
            self.ivWind.hidden = false
            self.lbWind.hidden = false
        }else{
            self.ivWind.hidden = true
            self.lbWind.hidden = true
        }
        
        
        let cb:Chosen? = Background.getOne()
        let cf:Chosen? = Figure.getOne()
        let co:Chosen? = Oneword.getOne()
        if let word = co?.comment{
            let oRange = NSMakeRange(0, count(word))
            var words = NSMutableAttributedString(string: word)
            words.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
            var linestyle = NSMutableParagraphStyle()
            linestyle.lineHeightMultiple = 1.42
            linestyle.alignment = NSTextAlignment.Center
            words.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
            //            self.lbWord.shadowColor = UIColor(white: 0, alpha: 0.5)
            //            self.lbWord.shadowOffset = CGSizeMake(6,6)
            self.lbWord.layer.shadowColor = UIColor.blackColor().CGColor
            self.lbWord.layer.shadowRadius = 6.0
            self.lbWord.layer.shadowOpacity = 0.5
            self.lbWord.layer.shadowOffset = CGSizeMake(0, 0)
            self.lbWord.attributedText = words
        }
        if let pathBack = cb?.path {
            self.mBackground.image = UIImage(contentsOfFile: center.getPath(pathBack))
        }
        if let pathFig = cf?.path {
            println("Test:\(center.getPath(pathFig))\n")
            //            if NSFileManager.defaultManager().fileExistsAtPath(pathFig){
            self.mFigure.image = UIImage(contentsOfFile: center.getPath(pathFig))
            
            //            self.mFigure.
            //            }
        }
//        let cTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: "clockSetup:", userInfo: nil, repeats: false)
//        cTimer.fire()
//        

    }
    func chi_week(dayInWeek:Int) -> String {
        var ret:String
        switch dayInWeek {
        case 7 :
            ret = "周日"
        case 1:
            ret = "周一"
        case 2:
            ret = "周二"
        case 3:
            ret = "周三"
        case 4:
            ret = "周四"
        case 5:
            ret = "周五"
        case 6:
            ret = "周六"
        default:
            ret = "周日"
        }
        return ret
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let height:CGFloat = scrollView.bounds.size.height
        let position:CGFloat = max(scrollView.contentOffset.y, 0.0)
        // 2
        let percent:CGFloat = min(position / height, 1.0)
        scrollView.bounces = (scrollView.contentOffset.y < 200)
        
        if percent > 0.9 {
            self.view.sendSubviewToBack(openCityBtn)
            self.view.sendSubviewToBack(openShareBtn)
            self.view.sendSubviewToBack(openSettingBtn)
        }
        if percent < 0.1 {
            self.view.bringSubviewToFront(openCityBtn)
            self.view.bringSubviewToFront(openShareBtn)
            self.view.bringSubviewToFront(openSettingBtn)
        }
        
        // 3
        //        self.blurredImageView.alpha = percent
        //        self.blurredFigureView.alpha = percent
        //        if percent > 0.3 {
        //            self.blurredImageView.hidden = false
        //            self.blurredFigureView.hidden = false
        //        }else{
        //            self.blurredImageView.hidden = true
        //            self.blurredFigureView.hidden = true
        //        }
    }
    
    func getWindDisplay(wind:String) -> String{
        let level:Int = wind.stringByReplacingOccurrencesOfString("级", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
        var ret:String
        
        switch(level){
        case 0:
            ret = "静悄悄"
        case 1:
            ret = "没啥风"
        case 2:
            ret = "风儿轻轻吹"
        case 3:
            ret = "小微风"
        case 4:
            ret = "温柔的风"
        case 5:
            ret = "小清风"
        case 6:
            ret = "刮风了"
        case 7:
            ret = "刮大风了"
        case 8:
            ret = "风好大呀"
        case 9:
            ret = "树都挂歪了"
        case 10:
            ret = "不能出门了"
        case 11:
            ret = "不能出门了"
        case 12:
             ret = "龙~卷~风~"
        case 13:
             ret = "龙~卷~风~"
        case 14:
             ret = "龙~卷~风~"
        case 15:
             ret = "龙~卷~风~"
        default:
            ret = "龙~卷~风~"
        }
        return ret
    }
    func clockSetup(){
        if isClockSetup {
            return
        }
        isClockSetup = true
//        let dailyArray = dailyData!.values.array
        ivLabelBackground = UIImageView(image: UIImage(named: "white_block17"))
        ivLabelBackground.layer.cornerRadius = ivLabelBackground.frame.size.width/2
        ivLabelBackground.clipsToBounds = true
        ivLabelBackground.setTranslatesAutoresizingMaskIntoConstraints(false)
        layer_number_back.addSubview(ivLabelBackground)
        
        ivLabelBackground.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:17))
        ivLabelBackground.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:17))
        
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekday, fromDate: now)
        var month = components.month
        var day = components.day
        var dayInWeek = components.weekday
        var hour =  components.hour
        var hourx = hour
        var arr_list = Global.arr_morning
        if hour > 12 {
            hour = hour - 12
            arr_list = Global.arr_afternoon
        }
        if hour == 0{
            arr_list = Global.arr_afternoon
        }
        for idxa in arr_list {
            var idx = idxa
            if idxa > 12{
                idx = idxa - 12
            }
            
            var lb:UILabel = UILabel()
            var numb = NSMutableAttributedString(string: String(format: "%02d",idxa))
            numb.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, 2))
            if hour == idx {
                numb.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgba: "#02a8f3"), range: NSMakeRange(0, 2))
            }
            numb.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10), range: NSMakeRange(0, 2))
            //            lb.layer.shadowColor = UIColor.blackColor().CGColor
            //            lb.layer.shadowRadius = 6.0
            //            lb.layer.shadowOpacity = 0.5
            //            lb.layer.shadowOffset = CGSizeMake(0, 0)
            lb.attributedText = numb
            
            lb.autoresizesSubviews = true
            lb.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_number.addSubview(lb)
            if idx == 12 || idx == 0 {
                layer_number.addConstraint(NSLayoutConstraint(item: lb, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_number, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                layer_number.addConstraint(NSLayoutConstraint(item: lb, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_number, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -85))
            }else{
                var horizon =  CGFloat(round(85 * sin( Double(idx) * Double(M_PI) / Double(6.0) )))
                var vertical = CGFloat(round(85 - (85 * cos(Double(idx) * Double(M_PI) / Double(6.0)) )))
                layer_number.addConstraint(NSLayoutConstraint(item: lb, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: lbNumber[0], attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: horizon ))
                layer_number.addConstraint(NSLayoutConstraint(item: lb, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: lbNumber[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: vertical))
            }
            lbNumber.append(lb)
            
            if hour == idx{
                layer_center.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: lb, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                layer_center.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: lb, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
            }
            
            var dtuple:(Int,String)? = dailyData![idxa]
            if dtuple != nil {
                var icon = UIImageView(image: center.getWeatherIcon(dtuple!.1,hour:idxa))//UIImage(named: ))
                icon.setTranslatesAutoresizingMaskIntoConstraints(false)
                layer_icons.addSubview(icon)
                icon.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:31))
                icon.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:31))
                if idx == 12 || idx == 0 {
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_icons, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_icons, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -120))
                }else{
                    var horizon =  CGFloat(round(120 * sin( Double(idx) * Double(M_PI) / Double(6.0) )))
                    var vertical = CGFloat(round(120 - (120 * cos(Double(idx) * Double(M_PI) / Double(6.0)) )))
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: icon_weathers[0], attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: horizon ))
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: icon_weathers[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: vertical))
                }
                icon_weathers.append(icon)
            }

            
            var dot = UIImageView(image: UIImage(named: "white_block"))
            dot.layer.cornerRadius = dot.frame.size.width/2
            dot.clipsToBounds = true
            dot.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_dots.addSubview(dot)
            
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:5))
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:5))
            if idx == 12 || idx == 0 {
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_dots, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_dots, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -100))
            }else{
                var horizon =  CGFloat(round(100 * sin( Double(idx) * Double(M_PI) / Double(6.0) )))
                var vertical = CGFloat(round(100 - (100 * cos(Double(idx) * Double(M_PI) / Double(6.0)) )))
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: ivDots[0], attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: horizon ))
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: ivDots[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: vertical))
            }
            
            ivDots.append(dot)
        }
        
    }
    func lineChartCalc(){
        var hight_max = highData.reduce(Int.min, combine: { max($0, $1) })
        var low_min = lowData.reduce(Int.max, combine: { min($0, $1) })
        
        var dist = hight_max - low_min
        var wave_layer_height:CGFloat = CGFloat(self.layer_highWave.bounds.size.height)
        var base_height:CGFloat = CGFloat( CGFloat(wave_layer_height) / CGFloat(hight_max) )
        var base_width:CGFloat = CGFloat( screenWidth / 10.0 )
        
        let higherShape = CAShapeLayer()
        self.layer_highWave.layer.addSublayer(higherShape)
        
        var highPoints:[CGPoint]! = []
        var y:CGFloat =  CGFloat(wave_layer_height - ( (CGFloat(highData[0])) * base_height)) - 10
        highPoints.append(CGPointMake(0 , y ))
        for idx in 1...5 {
            y = CGFloat(wave_layer_height-(CGFloat(highData[idx-1]) * base_height) )
            highPoints.append(CGPointMake(((2 * CGFloat(idx) - 1) * base_width), y ))
        }
        //        y = CGFloat(wave_layer_height - ((CGFloat(highData[4])) * base_height) )
        highPoints.append(CGPointMake( CGFloat(screenWidth), y-10))
        highPoints.append(CGPointMake( CGFloat(screenWidth), wave_layer_height))
        
        higherShape.opacity = 0.5
        //        higherShape.lineWidth = 1
        higherShape.lineJoin = kCALineCapRound //kCALineJoinMiter //
        higherShape.fillColor = UIColor(white: 255, alpha: 0.4).CGColor
        
        let higherPath = UIBezierPath()
        higherPath.moveToPoint(CGPointMake(0, CGFloat(wave_layer_height) ))
        
        for point:CGPoint in highPoints {
            higherPath.addLineToPoint(point)
        }
        higherPath.closePath()
        higherShape.path = higherPath.CGPath
        
        //        // ==================
        //
        let lowerShape = CAShapeLayer()
        self.layer_lowWave.layer.addSublayer(lowerShape)
        
        //        hight_max = lowData.reduce(Int.min, combine: { max($0, $1) })
        wave_layer_height = CGFloat(self.layer_lowWave.bounds.size.height)
        base_height = CGFloat( CGFloat(wave_layer_height) / CGFloat(hight_max))
        
        var lowPoints:[CGPoint]! = []
        y =  CGFloat(wave_layer_height - ( (CGFloat(lowData[0]) ) * base_height)) + 10
        lowPoints.append(CGPointMake(0 , y ))
        for idx in 1...5 {
            y = CGFloat(wave_layer_height-(CGFloat(lowData[idx-1]) * base_height) )
            lowPoints.append(CGPointMake(((2 * CGFloat(idx) - 1) * base_width), y ))
        }
        y = CGFloat(wave_layer_height - ((CGFloat(lowData[4])) * base_height) )-5
        lowPoints.append(CGPointMake( CGFloat(screenWidth), y))
        lowPoints.append(CGPointMake( CGFloat(screenWidth), wave_layer_height))
        
        lowerShape.opacity = 0.5
        //        lowerShape.lineWidth = 1
        lowerShape.lineJoin = kCALineCapRound //kCALineJoinMiter
        lowerShape.fillColor = UIColor(white: 255, alpha: 0.3).CGColor
        
        let lowerPath = UIBezierPath()
        lowerPath.moveToPoint(CGPointMake(0, CGFloat(wave_layer_height) ))
        for point:CGPoint in lowPoints {
            lowerPath.addLineToPoint(point)
        }
        lowerPath.closePath()
        
        lowerShape.path = lowerPath.CGPath
    }
    
    func lineChartSetup(){
        isChartSetup = true
//        if self.weekData == nil {
//            let aTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: "lineChartSetup:", userInfo: nil, repeats: false)
//            aTimer.fire()
//            return
//        }
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekday, fromDate: now)
        var month = components.month
        var day = components.day
        var dayInWeek = components.weekday

//        let weekArray = [weekData![0],weekData![1],weekData![2],weekData![3],weekData![4]]//weekData!.values.array
        let part_five = screenWidth / 5
        let part_ten = screenWidth / 10
        
        for idx in 1...5 {
            highData.append(weekData![idx-1]!.0)
            lowData.append(weekData![idx-1]!.1)
        }
        
        var highData_max = highData.reduce(Int.min, combine: { max($0, $1) })
        var lowData_max = lowData.reduce(Int.min, combine: { max($0, $1) })
        var high_division:CGFloat = 1.0 / CGFloat(highData_max)
        
        for idx in 1...5 {
            var bar:UIView! = UIView()
            bar.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_bar.addSubview(bar)
            bar.addConstraint(NSLayoutConstraint(item: bar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: part_five))
            layer_bar.addConstraint(NSLayoutConstraint(item: bar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_bar, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
            layer_bar.addConstraint(NSLayoutConstraint(item: bar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: layer_bar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
            if idx == 1 {
                layer_bar.addConstraint(NSLayoutConstraint(item: bar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_bar, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
            }else{
                let cou = lybars.count
                layer_bar.addConstraint(NSLayoutConstraint(item: bar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: lybars[idx-2], attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
            }
            lybars.append(bar)
            
            let weektuple = weekData![idx-1]!
            var lbtime:UILabel! = UILabel()
            var ivweatherx:UIImageView! = UIImageView(image: center.getWeatherIcon(weektuple.2,hour:12))///UIImage(named:"icon_home_weather_daytime_cloudy01"))
            
            lbtime.setTranslatesAutoresizingMaskIntoConstraints(false)
            ivweatherx.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            var new_date:NSDate
            var str_time = "\(month)/\(day)\n"
            if idx == 1 {
                str_time = "\(month)/\(day)\n" + "今天"
            }else{
                new_date = now.dateByAddingTimeInterval(Double(86400 * idx-1))
                components = calendar.components( NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekday, fromDate: new_date)
                month = components.month
                day = components.day
                dayInWeek = components.weekday
                str_time = "\(month)/\(day)\n" + chi_week(dayInWeek)
            }
            var range = NSMakeRange(0, count(str_time))
            var str_attribute = NSMutableAttributedString(string: str_time)
            str_attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
            str_attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: range)
            var linestyle = NSMutableParagraphStyle()
            linestyle.lineHeightMultiple = 1.2
            linestyle.alignment = NSTextAlignment.Center
            str_attribute.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: range)
            //                        lb.layer.shadowColor = UIColor.blackColor().CGColor
            //                        lb.layer.shadowRadius = 6.0
            //                        lb.layer.shadowOpacity = 0.5
            //                        lb.layer.shadowOffset = CGSizeMake(0, 0)
            lbtime.autoresizesSubviews = true
            lbtime.numberOfLines = 2
            lbtime.attributedText = str_attribute
            
            layer_waveTop.addSubview(lbtime)
            layer_waveTop.addSubview(ivweatherx)
            
            layer_waveTop.addConstraint(NSLayoutConstraint(item: lbtime, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveTop, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: lbtime, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveTop, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: CGFloat( CGFloat(part_ten)*(2*CGFloat(idx)-1)) ))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: lbtime, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 4.0))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: lbtime, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 31))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 31))
            
            lbBarTime.append(lbtime)
            ivBarWeather.append(ivweatherx)
            
            
            // Dots start
            var dot:UIImageView! = UIImageView(image:UIImage(named: "white_block8"))
            dot.layer.cornerRadius = dot.frame.size.width/2
            dot.clipsToBounds = true
            dot.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_waveDots.addSubview(dot)
            
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            //            highData dots
            var calc:CGFloat = 1-((high_division)*CGFloat(highData[idx-1]))
            if calc == 0{
                layer_waveDots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Top, multiplier: 1 , constant: 0))
            }else{
                layer_waveDots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Bottom, multiplier: calc , constant: 0))
            }
            layer_waveDots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Left, multiplier: 1.0 , constant:  CGFloat(CGFloat(part_ten)*(2*CGFloat(idx)-1))))
            ivWaveHighDots.append(dot)
            
            var ldot:UIImageView! = UIImageView(image:UIImage(named: "white_block8"))
            ldot.layer.cornerRadius = ldot.frame.size.width/2
            ldot.clipsToBounds = true
            ldot.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_waveDots.addSubview(ldot)
            
            ldot.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            ldot.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            //            highData dots
            calc = 1-((high_division)*CGFloat(lowData[idx-1]))
            if calc == 0{
                layer_waveDots.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Top, multiplier: 1 , constant: 0))
            }else{
                layer_waveDots.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Bottom, multiplier: calc , constant: 0))
            }
            layer_waveDots.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Left, multiplier: 1.0 , constant:  CGFloat(CGFloat(part_ten)*(2*CGFloat(idx)-1))))
            
            ivWaveLowDots.append(ldot)
            
            
            var lbhNum:UILabel! = UILabel()
            var lblNum:UILabel! = UILabel()
            lbhNum.setTranslatesAutoresizingMaskIntoConstraints(false)
            lblNum.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            range = NSMakeRange(0, count("\(highData[idx - 1])°"))
            str_attribute = NSMutableAttributedString(string: "\(highData[idx - 1])°")
            str_attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
            str_attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: range)
            lbhNum.attributedText = str_attribute
            lbhNum.autoresizesSubviews = true
            
            range = NSMakeRange(0, count("\(lowData[idx - 1])°"))
            str_attribute = NSMutableAttributedString(string: "\(lowData[idx - 1])°")
            str_attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
            
            str_attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: range)
            lblNum.attributedText = str_attribute
            lblNum.autoresizesSubviews = true
            
            layer_highLabel.addSubview(lbhNum)
            layer_lowLabel.addSubview(lblNum)
            
            layer_wave.addConstraint(NSLayoutConstraint(item: lbhNum, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: dot, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            layer_wave.addConstraint(NSLayoutConstraint(item: lbhNum, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: dot, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -4))
            
            layer_wave.addConstraint(NSLayoutConstraint(item: lblNum, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: ldot, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            layer_wave.addConstraint(NSLayoutConstraint(item: lblNum, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: ldot, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -4))
            
            lbLowNumber.append(lblNum)
            lbHighNumber.append(lbhNum)
        }
        lineChartCalc()
    }
    func constraintSetup(){
        
        // layer bar Constraint
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_bar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_bar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_bar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_bar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        // layer waveTop
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveTop, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveTop, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveTop, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveTop, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        // layer waveDots
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveDots, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveDots, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: -120))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveDots, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveDots, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        // layer highLabel
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        // layer lowLabel
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        
        // layer_highWave Constraint
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highWave, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highWave, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: -120))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highWave, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highWave, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        // layer_lowWave Constraint
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: -120))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        // layer wave Constraint
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        //        layer_wave.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: ))
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.layer_center, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 30))
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        //layer center postion
        self.page2.addConstraint(NSLayoutConstraint(item: layer_center, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.page2.addConstraint(NSLayoutConstraint(item: self.layer_center, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        // layer_center top margin
        self.page2.addConstraint(NSLayoutConstraint(item: layer_center, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 30))
        
        // Center Weather Icon Constrain
        ivWeatherIcon.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:62))
        ivWeatherIcon.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:62))
        
        // layer_center Contraint
        layer_center.addConstraint(NSLayoutConstraint(item: self.layer_center, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 282))
        layer_center.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: lbTodayWeather, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem:layer_center , attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: lbTodayWeather, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: ivWeatherIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        // other layer's contraint
        // X
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number_back, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_dots, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_icons, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        // Y
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number_back, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_dots, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_icons, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        // Width
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number_back, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_dots, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_icons, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        // Height
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number_back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_number, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_dots, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: layer_icons, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        

    }
}

extension ViewController{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_choose_city"{
            var cityCtler:CityController = segue.destinationViewController as! CityController
            cityCtler.delegate = self
        }
    }
    func changePublishTime(aTimer:NSTimer){
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitMinute, fromDate: now)
        var minutes = components.minute
        if (minutes >= 30) {
            minutes = minutes - 30
        }
        var tip:String
        if (minutes <= 3) {
            tip = "刚刚更新"    //res.getString(R.string.just_now);
        } else {
            tip = "\(minutes)分钟前更新"//res.getString(R.string.minutes_ago);
        }
        lbUpdateTime.text = tip;
        
    }
}


extension ViewController:PassValueDelegate{
    func setValue(dict: NSDictionary) {
        let from:String = dict.valueForKey("from") as! String
        if from == "city"{
            let city_display = dict.valueForKey("city_display_name") as? String
            if city_display != "" {
                self.lbLocation.text = city_display
                isClockSetup = false
                isChartSetup = false
//                self.center.start(updateViews: {
//                    self.updateView()
//                })
            }
        }
    }
}