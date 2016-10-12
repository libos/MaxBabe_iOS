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
    
    @IBOutlet weak var mBackgroundAnim: UIView!
    
    @IBOutlet weak var mBackground: UIImageView!
    @IBOutlet weak var mFigure: UIImageView!
    
    @IBOutlet weak var mFigureAnimation: UIImageView!
    
    @IBOutlet weak var lbWord: UILabel!
    
    @IBOutlet weak var tvWeather: UILabel!
    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var mTemp: UICountingLabel!
    @IBOutlet weak var lbWind: UILabel!
    @IBOutlet weak var lbHumi: UILabel!
    
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbUpdateTime: UILabel!
    
    @IBOutlet weak var lbWordCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var animWindLeft: NSLayoutConstraint!
    
    @IBOutlet weak var temperatureBtn: UIButton!
    //    @IBOutlet weak var lbTomoHighTemp: UILabel!
    //    @IBOutlet weak var lbTomoLowTemp: UILabel!
    
    //    @IBOutlet weak var ivHazeEnd: UIImageView!
    //    @IBOutlet weak var ivHazeBegin: UIImageView!
    @IBOutlet weak var ivWind: UIImageView!
    @IBOutlet weak var ivWet: UIImageView!
    
    @IBOutlet weak var openCityBtn: UIButton!
    @IBOutlet weak var openShareBtn: UIButton!
    @IBOutlet weak var openSettingBtn: UIButton!
    
    
    @IBOutlet weak var ivAqi: UIImageView!
    @IBOutlet weak var lbAqi: UILabel!
    @IBOutlet weak var lbAqiNumber: UILabel!
    
    @IBOutlet weak var viewLay: UIView!
    
    
    @IBOutlet weak var mTempHorizon:NSLayoutConstraint!
    
    @IBOutlet weak var mWeatherIconHorizon:NSLayoutConstraint!
    @IBOutlet weak var mWeatherHorizon:NSLayoutConstraint!

    let modelName = UIDevice.currentDevice().modelName

    var nothing:UIView!
    var form_init:Bool = true
    var ptf : SSPullToRefreshView!
    
    var screenHeight:CGFloat!
    var screenWidth:CGFloat!
    //    var blurredImageView:UIImageView!
    //    var blurredFigureView:UIImageView!
    var detailView:UIScrollView!
    //    var refreshControl:UIRefreshControl!
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
    
    var ivPage2Location:UIImageView!
    var lbPage2Location:UILabel!
    
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
    var part_ten:CGFloat =  0
    var colorOfhour = Global.colorOfhour()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nothing = UIView()
        self.view.addSubview(self.nothing)
        self.form_init = true

        
        self.ivPage2Location = UIImageView(image: UIImage(named: "icon_list_location"))
        self.ivPage2Location.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.lbPage2Location = UILabel()
        self.lbPage2Location.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.lbPage2Location.textColor = UIColor.whiteColor()
        self.lbPage2Location.textAlignment = NSTextAlignment.Left
        self.lbPage2Location.font = UIFont.systemFontOfSize(15.0)
        if city.city_name != nil {
            if city.district != nil && city.district != "" {
                let tmp = center.s2t(city.district)
                lbLocation.text = tmp
                self.lbPage2Location.text = tmp
            }else if city.city_name != nil{
                let tmp = center.s2t(city.city_name)
                lbLocation.text = tmp
                self.lbPage2Location.text = tmp
            }
        }
        city.addObserver(self, forKeyPath: "city_name", options: NSKeyValueObservingOptions.New, context: nil)
        weather.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.New, context: nil)
        weather.addObserver(self, forKeyPath: "dailyState", options: NSKeyValueObservingOptions.New, context: nil)
        weather.addObserver(self, forKeyPath: "weekState", options: NSKeyValueObservingOptions.New, context: nil)
        
        // TODO
        self.screenHeight =  UIScreen.mainScreen().bounds.size.height
        self.screenWidth = UIScreen.mainScreen().bounds.size.width
        self.part_ten = screenWidth / 10
        
        //        let xxx:UIView = UIView(frame: self.view.frame)
        //        xxx.drawRect(self.view.layer.renderInContext(UIGraphicsGetCurrentContext()))
        
        //        self.refreshControl = UIRefreshControl()
        //        self.refreshControl.addTarget(self, action: "refreshTask:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.detailView = UIScrollView(frame: self.view.bounds)
        self.detailView.contentSize = CGSizeMake(self.screenWidth,self.screenHeight*2)
        self.detailView.backgroundColor = UIColor.clearColor()//UIColor(white: 0, alpha: 0.8)
        self.detailView.delegate = self
        self.detailView.pagingEnabled = true
        self.detailView.scrollEnabled = true
        if self.city.city_name == nil {
            self.detailView.scrollEnabled = false
        }
        if center.ios8() {
            self.detailView.alwaysBounceVertical = false
        }else{  
            self.detailView.alwaysBounceVertical = true
        }

        
        self.detailView.alwaysBounceHorizontal = false
        self.detailView.showsHorizontalScrollIndicator = false
        self.detailView.showsVerticalScrollIndicator = false

        
        self.page2 = UIView(frame: CGRect(x: 0, y: screenHeight , width: self.view.bounds.size.width, height: screenHeight))
        self.page2.backgroundColor = Global.colorOfhour()
        viewLay.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.detailView.addSubview(viewLay)
        self.detailView.addSubview(page2)
        self.view.addSubview(self.detailView)
        
        ptf = SSPullToRefreshView(scrollView: detailView, delegate: self)
        ptf.contentView = UIPtfView(frame: CGRectZero)
        
        layer_center = UIView()
        layer_center.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        ivWeatherIcon = UIImageView(image: UIImage(named: "icon_home_weather_daytime_clear01"))
        ivWeatherIcon.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        lbTodayWeather = UILabel()
        lbTodayWeather.setTranslatesAutoresizingMaskIntoConstraints(false)
        
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
        // MARK: ADD Page2 Location
        self.page2.addSubview(ivPage2Location)
        self.page2.addSubview(lbPage2Location)
        
        
        viewLay.addConstraint(NSLayoutConstraint(item: viewLay, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenWidth))
        viewLay.addConstraint(NSLayoutConstraint(item: viewLay, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: screenHeight))
        detailView.addConstraint(NSLayoutConstraint(item: viewLay, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: detailView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        detailView.addConstraint(NSLayoutConstraint(item: viewLay, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: detailView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        
        
        self.page2.addConstraint(NSLayoutConstraint(item: self.ivPage2Location, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20))
        self.page2.addConstraint(NSLayoutConstraint(item: self.ivPage2Location, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20))
        self.page2.addConstraint(NSLayoutConstraint(item: self.ivPage2Location, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 20))
        self.page2.addConstraint(NSLayoutConstraint(item: self.ivPage2Location, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 30))
        
        self.page2.addConstraint(NSLayoutConstraint(item: self.lbPage2Location, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.ivPage2Location, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 10))
        self.page2.addConstraint(NSLayoutConstraint(item: self.lbPage2Location, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.ivPage2Location, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
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
        self.view.bringSubviewToFront(temperatureBtn)
        if city.city_name != nil{
            retriveData()
        }
        
        constraintSetup()
        
        // MARK: - Timer Setup
        let aTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(200.0, target: self, selector: "changePublishTime:", userInfo: nil, repeats: true)
        aTimer.fire()
        
        // 600 minutes
        let weatherDataTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(600.0, target: self, selector: "timerFiredTask:", userInfo: nil, repeats: true)
        weatherDataTimer.fire()
        
        // MARK: - Init Animation Pre
        mTempHorizon.constant = 50
        self.mTemp.layoutIfNeeded()
        self.ivWeather.layoutIfNeeded()
        self.tvWeather.layoutIfNeeded()
        
        
        animWindLeft.constant = -50
        self.lbWind.alpha = 0.0
        self.ivWind.alpha = 0.0
        self.lbHumi.alpha = 0.0
        self.ivWet.alpha = 0.0
        self.ivAqi.alpha = 0.0
        self.lbAqi.alpha = 0.0
        self.lbAqiNumber.alpha = 0.0
        self.lbWind.layoutIfNeeded()
        self.ivWind.layoutIfNeeded()
        self.lbHumi.layoutIfNeeded()
        self.ivWet.layoutIfNeeded()
        self.ivAqi.layoutIfNeeded()
        self.lbAqi.layoutIfNeeded()
        self.lbAqiNumber.layoutIfNeeded()
        
    }
    
    // MARK: - Observer
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "city_name"{
            if self.city.city_name != nil {
                self.detailView.scrollEnabled = true
            }
            if city.district != nil && city.district != "" {
                let tmp = center.s2t(city.district)
                lbLocation.text = tmp
                self.lbPage2Location.text = tmp
                
            }else if city.city_name != nil{
                let tmp = center.s2t(city.city_name)
                lbLocation.text = tmp
                self.lbPage2Location.text = tmp
                
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
            }else{
                //                self.weather.getDaily()
            }
        }else if keyPath == "weekState" {
            if weather.state == ".Stored" {
                if weather.weekState == ".WeekDone" {
                    self.weekData = self.weather.weekData
                    self.lineChartSetup()
                }else if weather.weekState == ".Downloaded"{
                    self.weekData = self.weather.getWeekNoStateChange()
                    //                    if self.weekData == nil || self.weekData![0] == nil {
                    //                         self.lineChartSetup()
                    //                    }
                }else if weather.weekState == ".Retry" {
                    self.weekData = self.weather.getWeek()
                }
            }
        }
    }
    
    func retriveData(){
        if city.city_name == nil {
            return
        }
        self.weather.city_name = city.cleanCityName()
        if weather.state == ".Idle" || weather.state == ".Stored"{
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
        MobClick.beginLogPageView(toString(self.dynamicType))
        isViewAppeared = true
        if city.city_name != nil {
            if weather.weekState == ".WeekDone" {
                self.weekData = self.weather.weekData
                self.lineChartSetup()
            }else if weather.weekState == ".Downloaded"{
                self.weekData = self.weather.getWeek()
                self.lineChartSetup()
            }else{
                self.weather.getWeek()
            }
        }
        //        let bTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: "timerWeekDataDownloadFired:", userInfo: nil, repeats: true)
        //        bTimer.fire()
        
        
        //MARK: - Init Animation
        //
        //                let animation:CATransition = CATransition()
        //                animation.timingFunction = CAMediaTimingFunction(name:
        //                    kCAMediaTimingFunctionLinear)
        //                animation.type = kCATransitionFromRight
        //                animation.duration = 1
        //                animation.delegate = self
        //                animation.setValue("the_init_mTemp_animation", forKey: "id")
        //                self.mTemp.layer.addAnimation(animation, forKey: kCATransitionFromRight)
        //    @IBOutlet weak var mWeatherIconHorizon:NSLayoutConstraint!
        //        @IBOutlet weak var mWeatherHorizon:NSLayoutConstraint!
        
        UIView.animateKeyframesWithDuration(2, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { () -> Void in
                self.mTempHorizon.constant = 16
                self.mTemp.layoutIfNeeded()
                self.tvWeather.layoutIfNeeded()
                self.ivWeather.layoutIfNeeded()
            })
            UIView.addKeyframeWithRelativeStartTime(0.3, relativeDuration: 0.5, animations: { () -> Void in
                self.lbWind.alpha = 1.0
                self.ivWind.alpha = 1.0
                self.animWindLeft.constant = 10
                self.lbWind.layoutIfNeeded()
                self.ivWind.layoutIfNeeded()
                
            })
            UIView.addKeyframeWithRelativeStartTime(0.4, relativeDuration: 0.5, animations: { () -> Void in
                self.lbHumi.alpha = 1.0
                self.ivWet.alpha = 1.0
                self.lbHumi.layoutIfNeeded()
                self.ivWet.layoutIfNeeded()
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                self.ivAqi.alpha = 1.0
                self.lbAqi.alpha = 1.0
                self.lbAqiNumber.alpha = 1.0
                self.ivAqi.layoutIfNeeded()
                self.lbAqi.layoutIfNeeded()
                self.lbAqiNumber.layoutIfNeeded()
            })
            }) { (finished:Bool) -> Void in
                
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(toString(self.dynamicType))
    }
    
    // MARK: - Timer Weather Data  111
    func timerFiredTask(timer:NSTimer){
        
        if !NSUserDefaults.standardUserDefaults().boolForKey(Global.SETTING_SWITCH_AUTOUPDATE) {
            return
        }
        
        var cv = (self.ptf.contentView as! UIPtfView).updateTime
        if cv != nil {
            let elapsedTime = NSDate().timeIntervalSinceDate(cv!)
            
            if elapsedTime < 90.0 {
                return
            }
        }
        self.center.start(updateViews: {
//            self.updateView()
        })
    }
    
    // MARK: - Week Timer Fetch
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
        self.mTemp.format = "%d°"
        self.mTemp.method = UILabelCountingMethodEaseInOut
        if self.form_init {
            self.mTemp.animationDuration = 3.0
            self.form_init = false
        }else{
            self.mTemp.animationDuration = 1.0
        }
        if weather.getTemp() == nil {
            self.mTemp.countFromCurrentValueTo(0)
        }else{
            if self.form_init {
                self.mTemp.countFromZeroTo(Float(weather.getTemp()!.toInt()!))
            }else{
                self.mTemp.countFromCurrentValueTo(Float(weather.getTemp()!.toInt()!))
            }
            //            self.mTemp.text = "\(weather.getTemp()!)°"
        }
        if weather.getWeather() == nil {
            self.tvWeather.text = "晴"
        }else{
            let wwwww = weather.getWeather()!
            self.tvWeather.text = center.s2t("\(wwwww)")!
            self.ivWeather.image = center.getWeatherIcon(wwwww)
        }
        
        
        //Todo set icon
        //
        if let aqi = weather.getAqi() {
            if aqi != 0{
                //                self.ivHazeEnd.hidden = false
                //                self.ivHazeBegin.hidden = false
                self.ivAqi.hidden = false
                self.lbAqi.hidden = false
                self.lbAqiNumber.hidden = false
                var aqi_msg: String = "空气超赞　　"
                var haze_level = 0
                // Log.e("err", data.toString())
                //                if (aqi <= 50) {
                //                    aqi_msg = "\(aqi) 超赞"
                //                    haze_level = 0
                //                } else if (aqi > 50 && aqi <= 100) {
                //                    aqi_msg = "\(aqi) 还不错"
                //                    haze_level = 1
                //                } else if (aqi > 100 && aqi <= 150) {
                //                    aqi_msg = "\(aqi) 有点差哦"
                //                    haze_level = 2
                //                } else if (aqi > 150 && aqi <= 200) {
                //                    aqi_msg = "\(aqi) 蛮差的"
                //                    haze_level = 3
                //                } else if (aqi > 200 && aqi <= 300) {
                //                    aqi_msg = "\(aqi) 别出门了"
                //                    haze_level = 4
                //                } else if (aqi > 300) {
                //                    aqi_msg = "\(aqi) 已爆表"
                //                    haze_level = 5
                //                }
                if (aqi <= 50) {
                    aqi_msg = "空气超赞　　"
                    haze_level = 0
                } else if (aqi > 50 && aqi <= 100) {
                    aqi_msg = "空气还不赖　"
                    haze_level = 1
                } else if (aqi > 100 && aqi <= 180) {
                    aqi_msg = "空气差差的　"
                    haze_level = 2
                } else if (aqi > 180 && aqi <= 222) {
                    aqi_msg = "尽量少出门　"
                    haze_level = 3
                } else if (aqi > 222 && aqi <= 350) {
                    aqi_msg = "别出门了　　"
                    haze_level = 4
                } else if (aqi > 350) {
                    aqi_msg = "空气污染爆表"
                    haze_level = 5
                }
                //Global.haze_leve[haze_level]
                self.ivAqi.image = UIImage(named: "icon_home_aqi" )
                self.ivAqi.contentMode = UIViewContentMode.ScaleAspectFit
                self.lbAqi.text = center.s2t(aqi_msg)
                self.lbAqiNumber.text = "\(aqi)"
                self.lbAqiNumber.textAlignment = NSTextAlignment.Left
                self.lbAqi.textAlignment = NSTextAlignment.Left
            }
        }else{
            //            self.ivHazeEnd.hidden = true
            //            self.ivHazeBegin.hidden = true
            self.ivAqi.hidden = true
            self.lbAqi.hidden = true
            self.lbAqiNumber.hidden = true
        }
        
        //        self.lbTomoWeather.text = "明天，\(weather.data.tomo_weather!)"
        //        if let tomoTemp = weather.data.tomo_temp {
        //            let ttemp:[String] = split(tomoTemp.stringByReplacingOccurrencesOfString("℃", withString: "")){$0 == "~"}
        //            var high:Int
        //            var low:Int
        //            if(ttemp[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt() > ttemp[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()){
        //                high = ttemp[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
        //                low = ttemp[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
        //            }else{
        //                high = ttemp[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
        //                low = ttemp[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
        //            }
        //            self.lbTomoHighTemp.text = "\(high)"
        //            self.lbTomoLowTemp.text = "\(low)"
        //        }else{
        //            let night = weather.data.next_night_temp?.stringByReplacingOccurrencesOfString("℃", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        //            let day = weather.data.next_day_temp?.stringByReplacingOccurrencesOfString("℃", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        //            if (night != nil && day != nil)  {
        //                var high:Int
        //                var low:Int
        //                if(night!.toInt() > day!.toInt()){
        //                    high = night!.toInt()!
        //                    low = day!.toInt()!
        //                }else{
        //                    high = day!.toInt()!
        //                    low = night!.toInt()!
        //                }
        //                self.lbTomoHighTemp.text = "\(high)"
        //                self.lbTomoLowTemp.text = "\(low)"
        //            }
        //        }
        let humi = weather.getHumi()
        if humi != nil && humi != "" {
            self.lbHumi.text = center.s2t("湿度 ")! + humi!
            self.ivWet.hidden = false
            self.lbHumi.hidden = false
        }else{
            //            self.ivWet
            self.ivWet.hidden = true
            self.lbHumi.hidden = true
        }
        let wind = weather.getWindLevel()
        if wind != nil && wind != ""  {
            self.lbWind.text = getWindDisplay(wind!)
            self.ivWind.hidden = false
            self.lbWind.hidden = false
        }else{
            self.ivWind.hidden = true
            self.lbWind.hidden = true
        }
        
        var st = NSUserDefaults.standardUserDefaults()
        
        let cb:Chosen? = Background.getOne()
        let cf:Chosen? = Figure.getOne()
        let co:Chosen? = Oneword.getOne()
        if let word = co?.comment{
            
            
            
            
            UIView.animateKeyframesWithDuration(2, delay: 0, options: UIViewKeyframeAnimationOptions.AllowUserInteraction , animations: { () -> Void in
                
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { () -> Void in
                    self.lbWord.alpha = 0.0
                })
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { () -> Void in
                    self.lbWordCenterY.constant = -95
                    self.lbWord.layoutIfNeeded()
                })
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                    self.lbWord.alpha = 1.0
                })
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                    self.lbWordCenterY.constant = -75
                    self.lbWord.layoutIfNeeded()
                })
                
                }, completion: { (finished:Bool) -> Void in
                    if finished {
                        
                    }
            })
            
            let animation:CATransition = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name:
                kCAMediaTimingFunctionLinear)
            animation.type = kCATransitionFade
            animation.duration = 1
            animation.delegate = self
            animation.setValue("the_word_show_animation", forKey: "id")
            self.nothing.layer.addAnimation(animation, forKey: kCATransitionFade)
            
            
            
            
            //            var anim_group:CAAnimationGroup = CAAnimationGroup()
            //            anim_group.animations =
            //            UIView.transitionWithView(self.lbWord, duration: 1.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            //                self.labelUpdate(word)
            //                }, completion: { (finished:Bool) -> Void in
            //
            //            })
            
            
            
            //            UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            ////                self.lbWordCenterY.constant = -95
            ////                self.lbWord.layoutIfNeeded()
            //                self.lbWord.center.y += 20
            //                self.lbWord.alpha = 0.0
            //                }, completion: { (finished:Bool) -> Void in
            //                    self.labelUpdate(word)
            //                    UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            ////                        self.lbWordCenterY.constant = -75
            ////                        self.lbWord.layoutIfNeeded()
            //                        self.lbWord.center.y -= 20
            //                        self.lbWord.alpha = 1.0
            //                    }, completion: nil)
            //
            //            })
            
            
            
            
        }
        if let pathBack = cb?.path {
            
            let tmp_path = center.getPath(pathBack)
            if NSFileManager().fileExistsAtPath(tmp_path){
                UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.mBackgroundAnim.alpha = 0.6
                    }, completion: { (finished:Bool) -> Void in
                        self.mBackground.image = UIImage(contentsOfFile: tmp_path)
                        self.mBackground.contentMode = UIViewContentMode.ScaleAspectFill
                        st.setValue(tmp_path, forKey: Global.THE_BACKGROUND)
                        UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            self.mBackgroundAnim.alpha = 0.0
                            }, completion: { (finise2:Bool) -> Void in
                                
                        })
                })
                
            }
        }
        if let pathFig = cf?.path {
            
            var animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
            animation.calculationMode = kCAAnimationDiscrete
            animation.duration =  1.3
            animation.values = Global.animationArray
            animation.repeatCount = 1
            animation.delegate = self
            animation.setValue("the_figure_show_animation", forKey: "id")
            self.mFigureAnimation.layer.addAnimation(animation, forKey: "animation")
            
            self.mFigure.alpha = 0.0
            let tmp_path = self.center.getPath(pathFig)
            if NSFileManager().fileExistsAtPath(tmp_path){
                self.mFigure.image = UIImage(contentsOfFile: tmp_path)
                st.setValue(tmp_path, forKey: Global.THE_FIGURE)
            }
        }
        st.synchronize()
        
        //
        
    }
    @IBAction func tempScrolltoPage(sender: AnyObject) {
        self.detailView.scrollRectToVisible(CGRectMake(0, self.screenHeight, self.screenWidth, self.screenHeight), animated: true)
    
    }
    
    func labelUpdate(word:String){
        var st = NSUserDefaults.standardUserDefaults()
        st.setValue(word, forKey: Global.THE_WORD)
        let oRange = NSMakeRange(0, count(word))
        var words = NSMutableAttributedString(string: self.center.s2t(word)!)
        words.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        var linestyle = NSMutableParagraphStyle()
        linestyle.lineHeightMultiple = 1.42
        linestyle.alignment = NSTextAlignment.Center
        words.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: oRange)
        words.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: oRange)
        
        self.lbWord.layer.shadowColor = UIColor.blackColor().CGColor
        self.lbWord.layer.shadowRadius = 6.0
        self.lbWord.layer.shadowOpacity = 0.5
        self.lbWord.layer.shadowOffset = CGSizeMake(0, 0)
        self.lbWord.attributedText = words
        
    }
    
    override func animationDidStart(anim: CAAnimation!) {
        //        println("start")
        if (anim.valueForKey("id") as? String) ==  "the_figure_show_animation" {
            UIView.animateWithDuration(0.01, delay: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.mFigure.alpha = 1.0
                }, completion: { (finished:Bool) -> Void in
                    
            })
        }
    }
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        //        println("done")
        
        if (anim.valueForKey("id") as? String) ==  "the_word_show_animation" {
            let co:Chosen? = Oneword.getOne()
            if let word = co?.comment{
                labelUpdate(word)
            }
        }
    }
    
    func chi_week(dayInWeek:Int) -> String {
        var ret:String
        switch dayInWeek {
        case 1 :
            ret = "周日"
        case 2:
            ret = "周一"
        case 3:
            ret = "周二"
        case 4:
            ret = "周三"
        case 5:
            ret = "周四"
        case 6:
            ret = "周五"
        case 7:
            ret = "周六"
        default:
            ret = "周日"
        }
        return ret
    }
    
    deinit{
        //        self.ptf = nil
        city.removeObserver(self, forKeyPath: "city_name")
        weather.removeObserver(self, forKeyPath: "state")
        weather.removeObserver(self, forKeyPath: "dailyState")
        weather.removeObserver(self, forKeyPath: "weekState")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        colorOfhour =  Global.colorOfhour()
        colorOfhour.colorWithAlphaComponent(1)
        self.page2.backgroundColor = colorOfhour
        self.viewLay.backgroundColor = UIColor.clearColor()
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= screenHeight*2/5 {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    // MARK: - Scroll Percent
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y < screenHeight)
        if (scrollView.contentOffset.y <= -100) {
            scrollView.contentOffset = CGPointMake(0, -100)
        }
        let height:CGFloat = scrollView.bounds.size.height
        let position:CGFloat = max(scrollView.contentOffset.y, 0.0)
        // 2
        let percent:CGFloat = 1 - min(position / height, 1.0)
        
        if percent > 0.9 {
            self.view.sendSubviewToBack(openCityBtn)
            self.view.sendSubviewToBack(openShareBtn)
            self.view.sendSubviewToBack(openSettingBtn)
            self.view.sendSubviewToBack(temperatureBtn)
        }
        if percent < 0.1 {
            self.view.bringSubviewToFront(openCityBtn)
            self.view.bringSubviewToFront(openShareBtn)
            self.view.bringSubviewToFront(openSettingBtn)
            self.view.bringSubviewToFront(temperatureBtn)
        }
        self.mFigure.alpha = percent
        self.mFigureAnimation.alpha = percent
        self.lbWord.alpha = percent
        self.lbLocation.alpha = percent
        self.lbUpdateTime.alpha = percent
        self.openShareBtn.alpha = percent
        self.openSettingBtn.alpha = percent
        self.page2.alpha = 1-percent
//        self.viewLay.backgroundColor = self.viewLay.backgroundColor?.colorWithAlphaComponent(1-percent)
        
    }
    
    func getWindDisplay(wind:String) -> String{
        let level:Int = wind.stringByReplacingOccurrencesOfString("级", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).toInt()!
        var ret:String
        
        switch(level){
        case 0:
            ret = "静悄悄　　"
        case 1:
            ret = "没啥风　　"
        case 2:
            ret = "风儿轻轻吹"
        case 3:
            ret = "小微风　　"
        case 4:
            ret = "温柔的风　"
        case 5:
            ret = "小清风　　"
        case 6:
            ret = "刮风了　　"
        case 7:
            ret = "刮大风了　"
        case 8:
            ret = "风好大呀　"
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
        return center.s2t(ret)!
    }
    func clockSetupx(timer:NSTimer){
        isClockSetup = false
        //         clockSetup()
    }
    // MARK: - Clock Setup
    func clockSetup(){
        if isClockSetup {
            return
        }
        isClockSetup = true
        let seconds = 60.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.isClockSetup = false
            self.clockSetup()
        })
        //        let cTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(600.0, target: self, selector: "clockSetupx:", userInfo: nil, repeats: false)
        //        cTimer.fire()
        //        let dailyArray = dailyData!.values.array
        layer_number.removeAllSubviews()
        layer_icons.removeAllSubviews()
        layer_dots.removeAllSubviews()
        if ivLabelBackground != nil {
            ivLabelBackground.removeFromSuperview()
        }
        lbNumber = []
        icon_weathers = []
        ivDots = []
        
        ivLabelBackground = UIImageView(image: UIImage(named: "white_block17"))
        ivLabelBackground.layer.cornerRadius = ivLabelBackground.frame.size.width/2
        ivLabelBackground.clipsToBounds = true
        ivLabelBackground.setTranslatesAutoresizingMaskIntoConstraints(false)
        //        ivLabelBackground.hidden = true
        layer_number_back.addSubview(ivLabelBackground)
        
        ivLabelBackground.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:17))
        ivLabelBackground.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:17))
        
        layer_center.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: layer_center, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant:0))
        
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekday, fromDate: now)
        var month = components.month
        var day = components.day
        var dayInWeek = components.weekday
        var hour =  components.hour
        var hourx = hour
        var arr_list = Global.arr_morning
        if hour >= 12 {
            hour = hour - 12
            arr_list = Global.arr_afternoon
        }
        if hour == 0{
            arr_list = Global.arr_afternoon
        }
        
        // MARK: the Center Image
        var nowTimeTuple:(Int,String)? = dailyData![hourx]
        ivWeatherIcon.image = center.getWeatherIconBig(nowTimeTuple!.1,hour:hourx)
        var strW = nowTimeTuple!.1
        let oRange = NSMakeRange(0, count(strW))
        var strWeather = NSMutableAttributedString(string: center.s2t(strW)!)
        strWeather.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: oRange)
        strWeather.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10), range: oRange)
        lbTodayWeather.layer.shadowColor = UIColor.blackColor().CGColor
        lbTodayWeather.layer.shadowRadius = 6.0
        lbTodayWeather.layer.shadowOpacity = 0.5
        lbTodayWeather.layer.shadowOffset = CGSizeMake(0, 0)
        lbTodayWeather.attributedText  = strWeather
        
        var first_ra:CGFloat = 75 //85
        var second_ra:CGFloat = 110 //120
        var third_ra:CGFloat = 90 //100
        for idxa in arr_list {
            var idx = idxa
            if idxa >= 12{
                idx = idxa - 12
            }
            
            var lb:UILabel = UILabel()
            var numb = NSMutableAttributedString(string: String(format: "%02d",idxa))
            numb.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, 2))
            if hour == idx {
                numb.addAttribute(NSForegroundColorAttributeName, value: Global.colorOfhour(), range: NSMakeRange(0, 2))
            }
            numb.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10), range: NSMakeRange(0, 2))
            lb.attributedText = numb
            
            lb.autoresizesSubviews = true
            lb.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_number.addSubview(lb)
            if idx == 12 || idx == 0 {
                layer_number.addConstraint(NSLayoutConstraint(item: lb, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_number, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                layer_number.addConstraint(NSLayoutConstraint(item: lb, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_number, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -first_ra))
            }else{
                var horizon =  CGFloat(round(first_ra * CGFloat(sin( Double(idx) * Double(M_PI) / Double(6.0) ))))
                var vertical = CGFloat(round(first_ra - (first_ra * CGFloat(cos(Double(idx) * Double(M_PI) / Double(6.0)) ))))
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
                if idx < hour {
                    icon.alpha = 0.4
                }
                layer_icons.addSubview(icon)
                icon.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:31))
                icon.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:31))
                if idx == 12 || idx == 0 {
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_icons, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_icons, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -second_ra))
                }else{
                    var horizon =  CGFloat(round(second_ra * CGFloat(sin( Double(idx) * Double(M_PI) / Double(6.0) ))))
                    var vertical = CGFloat(round(second_ra - (second_ra * CGFloat(cos(Double(idx) * Double(M_PI) / Double(6.0)) ))))
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: icon_weathers[0], attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: horizon ))
                    layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: icon_weathers[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: vertical))
                }
                icon_weathers.append(icon)
            }
            
            var dot = UIImageView(image: UIImage(named: "white_block"))
            dot.layer.cornerRadius = dot.frame.size.width/2
            dot.clipsToBounds = true
            dot.setTranslatesAutoresizingMaskIntoConstraints(false)
            if idx < hour {
                dot.alpha = 0.4
            }
            layer_dots.addSubview(dot)
            
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:5))
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:5))
            if idx == 12 || idx == 0 {
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_dots, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_dots, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -third_ra))
            }else{
                var horizon =  CGFloat(round(third_ra * CGFloat(sin( Double(idx) * Double(M_PI) / Double(6.0) ))))
                var vertical = CGFloat(round(third_ra - (third_ra * CGFloat(cos(Double(idx) * Double(M_PI) / Double(6.0)) ))))
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: ivDots[0], attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: horizon ))
                layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: ivDots[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: vertical))
            }
            
            ivDots.append(dot)
        }
        ivWeatherIcon.layoutIfNeeded()
        lbTodayWeather.layoutIfNeeded()
        layer_number.layoutIfNeeded()
        layer_icons.layoutIfNeeded()
        layer_dots.layoutIfNeeded()
        layer_number_back.layoutIfNeeded()
        layer_center.layoutIfNeeded()
        
    }
    // MARK: - Line Chart Calculate
    func lineChartCalc(#high_baseline:CGFloat,low_baseline:CGFloat){
        
        self.layer_highWave.layer.sublayers = nil
        self.layer_lowWave.layer.sublayers = nil
        
        var wave_layer_height:CGFloat = CGFloat(self.layer_highWave.bounds.size.height)
        
        // MARK: high Shape Line
        let higherShape = CAShapeLayer()
        self.layer_highWave.layer.addSublayer(higherShape)
        
        var highPoints:[CGPoint]! = []
        var y:CGFloat = wave_layer_height - high_baseline
        highPoints.append(CGPointMake(0 , y ))
        for idx in 1...5 {
            highPoints.append(ivWaveHighDots[idx-1].frame.centerPoint())
        }
        highPoints.append(CGPointMake( CGFloat(screenWidth), wave_layer_height-high_baseline))
        highPoints.append(CGPointMake( CGFloat(screenWidth), wave_layer_height))
        
        higherShape.opacity = 0.5
        higherShape.lineJoin = kCALineCapRound
        higherShape.fillColor = UIColor(white: 255, alpha: 0.4).CGColor
        
        let higherPath = UIBezierPath()
        higherPath.moveToPoint(CGPointMake(0, wave_layer_height))
        
        for point:CGPoint in highPoints {
            higherPath.addLineToPoint(point)
        }
        higherPath.closePath()
        higherShape.path = higherPath.CGPath
        
        // MARK: low Shape Line
        let lowerShape = CAShapeLayer()
        self.layer_lowWave.layer.addSublayer(lowerShape)
        
        wave_layer_height = CGFloat(self.layer_lowWave.bounds.size.height)
        
        var lowPoints:[CGPoint]! = []
        y = wave_layer_height - low_baseline
        lowPoints.append(CGPointMake(0 , y ))
        for idx in 1...5 {
            lowPoints.append(ivWaveLowDots[idx-1].frame.centerPoint())
        }
        lowPoints.append(CGPointMake( CGFloat(screenWidth), wave_layer_height-low_baseline))
        lowPoints.append(CGPointMake( CGFloat(screenWidth), wave_layer_height))
        
        lowerShape.opacity = 0.5
        lowerShape.lineJoin = kCALineJoinMiter //kCALineCapRound //
        lowerShape.fillColor = UIColor(white: 255, alpha: 0.3).CGColor
        
        let lowerPath = UIBezierPath()
        lowerPath.moveToPoint(CGPointMake(0, CGFloat(wave_layer_height) ))
        for point:CGPoint in lowPoints {
            lowerPath.addLineToPoint(point)
        }
        lowerPath.closePath()
        
        lowerShape.path = lowerPath.CGPath
    }
    
    func lineChartSetup(timer:NSTimer){
        lineChartSetup()
    }
    func lineChartSetup(){
        isChartSetup = true
        if self.weekData == nil || self.weekData![0] == nil {
            if weather.weekState == ".WeekDone" || weather.weekState == ".Downloaded" {
                self.weather.weekState = ".Retry"
            }
            //            self.weekData = self.weather.getWeek()
            //            let aTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: Selector("lineChartSetup"), userInfo: nil, repeats: false)
            //            aTimer.fire()
            return
        }
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekday, fromDate: now)
        var month = components.month
        var day = components.day
        var dayInWeek = components.weekday
        
        //        let weekArray = [weekData![0],weekData![1],weekData![2],weekData![3],weekData![4]]//weekData!.values.array
        let part_five = self.part_ten * 2
        
        highData = []
        lowData = []
        
        ivWaveHighDots = []
        ivWaveLowDots = []
        lybars = []
        lbBarTime = []
        ivBarWeather = []
        lbLowNumber = []
        lbHighNumber = []
        
        layer_waveTop.removeAllSubviews()
        layer_bar.removeAllSubviews()
        layer_waveDots.removeAllSubviews()
        
        layer_highLabel.removeAllSubviews()
        layer_lowLabel.removeAllSubviews()
        
        
        for idx in 1...5 {
            highData.append(weekData![idx-1]!.0)
            lowData.append(weekData![idx-1]!.1)
        }
        
        // MARK: - Draw New Lines
        var highAve = highData.average()
        var lowAve = lowData.average()
        
        // MARK: Base Line Calculate
        var high_baseline:CGFloat = 170         //0.26 * screenHeight //170px
        var low_baseline:CGFloat = 80           //0.14 * screenHeight  //80px
        
        var highMax = highData.reduce(Int.min, combine: { max($0, $1) })
        var lowMax = highData.reduce(Int.max, combine: { min($0, $1) })
        var maxDiff = highMax - lowMax
        
        var high_granularity:CGFloat = 3             //0.0075 * screenHeight         // 5px
        if self.modelName == "iPhone 6 Plus" || DeviceType.IS_IPHONE_6P {
            high_granularity = 4.5
        }
        if maxDiff > 10 && maxDiff <= 34 {
            high_granularity = 2             //0.003 * screenHeight         // 2px
        }else if maxDiff > 34 {
            high_granularity = 1             //0.0015 * screenHeight         // 1px
        }
        
        var curveTopBaseLine = high_baseline + high_granularity * 8 + 10
        
        highMax = lowData.reduce(Int.min, combine: { max($0, $1) })
        lowMax = lowData.reduce(Int.max, combine: { min($0, $1) })
        maxDiff = highMax - lowMax
        
        var low_granularity:CGFloat = 3             //0.0075 * screenHeight         // 5px
        if self.modelName == "iPhone 6 Plus" || DeviceType.IS_IPHONE_6P {
            low_granularity = 4.5
        }
        if maxDiff > 10 && maxDiff <= 34 {
            low_granularity = 2             //0.003 * screenHeight         // 2px
        }else if maxDiff > 34 {
            low_granularity = 1             //0.0015 * screenHeight         // 1px
        }
        
        if "iPhone 4S" == self.modelName  || "iPhone 4" == self.modelName || DeviceType.IS_IPHONE_4_OR_LESS{
            low_baseline = 50
            high_baseline = 100
            high_granularity = 1
            low_granularity = 1
            curveTopBaseLine = high_baseline + high_granularity * 8 + 10
        }
        
        for idx in 1...5 {
            var bar:UIView! = UIView()
            bar.setTranslatesAutoresizingMaskIntoConstraints(false)
            // MARK: The Background Bar
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
            
            // MARK: 获取一周的数据
            let weektuple = weekData![idx-1]!
            var lbtime:UILabel! = UILabel()
            var ivweatherx:UIImageView! = UIImageView(image: center.getWeatherIcon(weektuple.2,hour:12))///UIImage(named:"icon_home_weather_daytime_cloudy01"))
            
            lbtime.setTranslatesAutoresizingMaskIntoConstraints(false)
            ivweatherx.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            // MARK: 日期标签
            var new_date:NSDate
            var str_time = "\(month)/\(day)\n"
            if idx == 1 {
                str_time = "\(month)/\(day)\n" + "今天"
            }else{
                new_date = now.dateByAddingTimeInterval(Double(86400 * (idx-1)))
                components = calendar.components( NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekday, fromDate: new_date)
                month = components.month
                day = components.day
                dayInWeek = components.weekday
                str_time = "\(month)/\(day)\n" + chi_week(dayInWeek)
            }
            var range = NSMakeRange(0, count(str_time))
            var str_attribute = NSMutableAttributedString(string: center.s2t(str_time)!)
            str_attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
            str_attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(13), range: range)
            var linestyle = NSMutableParagraphStyle()
            linestyle.lineHeightMultiple = 1.2
            linestyle.alignment = NSTextAlignment.Center
            str_attribute.addAttribute(NSParagraphStyleAttributeName, value: linestyle, range: range)
            lbtime.autoresizesSubviews = true
            lbtime.numberOfLines = 2
            lbtime.attributedText = str_attribute
            
            layer_waveTop.addSubview(lbtime)
            layer_waveTop.addSubview(ivweatherx)
            
            
            layer_waveTop.addConstraint(NSLayoutConstraint(item: lbtime, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveTop, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: CGFloat( CGFloat(part_ten)*(2*CGFloat(idx)-1)) ))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveTop, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -(curveTopBaseLine)))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: lbtime, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 31))
            layer_waveTop.addConstraint(NSLayoutConstraint(item: ivweatherx, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 31))
            
            layer_waveTop.addConstraint(NSLayoutConstraint(item: lbtime, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: ivweatherx, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
            
            lbBarTime.append(lbtime)
            ivBarWeather.append(ivweatherx)
            
            // MARK: High Dots start
            var dot:UIImageView! = UIImageView(image:UIImage(named: "white_block8"))
            dot.layer.cornerRadius = dot.frame.size.width/2
            dot.clipsToBounds = true
            dot.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_waveDots.addSubview(dot)
            
            // MARK: ->High Dot Contstraint Height & Width
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            // MARK: ->High Data Position Calculates
            var calc:CGFloat = high_baseline + high_granularity * CGFloat(highData[idx-1] - highAve)
            layer_waveDots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Bottom, multiplier: 1 , constant: -calc))
            
            // MARK: ->High Dot Added
            layer_waveDots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Left, multiplier: 1.0 , constant:  CGFloat(CGFloat(part_ten)*(2*CGFloat(idx)-1))))
            ivWaveHighDots.append(dot)
            
            // MARK: Low Doos start
            var ldot:UIImageView! = UIImageView(image:UIImage(named: "white_block8"))
            ldot.layer.cornerRadius = ldot.frame.size.width/2
            ldot.clipsToBounds = true
            ldot.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_waveDots.addSubview(ldot)
            
            // MARK: ->Low Dot Contstraint Height & Width
            ldot.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            ldot.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:8))
            // MARK: ->Low Data Position Calculate
            calc = low_baseline + low_granularity * CGFloat(lowData[idx-1] - lowAve)
            layer_waveDots.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Bottom, multiplier: 1 , constant: -calc))
            
            // MARK: ->Low Dot Added
            layer_waveDots.addConstraint(NSLayoutConstraint(item: ldot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_waveDots, attribute: NSLayoutAttribute.Left, multiplier: 1.0 , constant:  CGFloat(CGFloat(part_ten)*(2*CGFloat(idx)-1))))
            ivWaveLowDots.append(ldot)
            
            // MARK: Temperature Label
            var lbhNum:UILabel! = UILabel()
            var lblNum:UILabel! = UILabel()
            lbhNum.setTranslatesAutoresizingMaskIntoConstraints(false)
            lblNum.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            // MARK: ->High Label Content Attribute String
            range = NSMakeRange(0, count("\(highData[idx - 1])°"))
            str_attribute = NSMutableAttributedString(string: "\(highData[idx - 1])°")
            str_attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
            str_attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: range)
            lbhNum.attributedText = str_attribute
            lbhNum.autoresizesSubviews = true
            
            // MARK: ->Low Label Content Attribute String
            range = NSMakeRange(0, count("\(lowData[idx - 1])°"))
            str_attribute = NSMutableAttributedString(string: "\(lowData[idx - 1])°")
            str_attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
            
            str_attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: range)
            lblNum.attributedText = str_attribute
            lblNum.autoresizesSubviews = true
            
            layer_highLabel.addSubview(lbhNum)
            layer_lowLabel.addSubview(lblNum)
            // MARK: ->Add High & Low Label Below dot
            layer_wave.addConstraint(NSLayoutConstraint(item: lbhNum, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: dot, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            layer_wave.addConstraint(NSLayoutConstraint(item: lbhNum, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: dot, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -4))
            
            layer_wave.addConstraint(NSLayoutConstraint(item: lblNum, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: ldot, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            layer_wave.addConstraint(NSLayoutConstraint(item: lblNum, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: ldot, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 4))
            
            lbLowNumber.append(lblNum)
            lbHighNumber.append(lbhNum)
        }
        layer_waveTop.layoutIfNeeded()
        layer_bar.layoutIfNeeded()
        layer_waveDots.layoutIfNeeded()
        
        layer_highLabel.layoutIfNeeded()
        layer_lowLabel.layoutIfNeeded()
        
        lineChartCalc(high_baseline:high_baseline,low_baseline: low_baseline)
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
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_waveDots, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
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
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highWave, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highWave, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_highWave, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        // layer_lowWave Constraint
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.layer_wave.addConstraint(NSLayoutConstraint(item: layer_lowWave, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: layer_wave, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        // layer wave Constraint
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        //        layer_wave.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: ))
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.layer_center, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        self.page2.addConstraint(NSLayoutConstraint(item: layer_wave, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        
        //layer center postion
        self.page2.addConstraint(NSLayoutConstraint(item: layer_center, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.page2.addConstraint(NSLayoutConstraint(item: self.layer_center, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        // layer_center top margin
        if self.modelName == "iPhone 6 Plus" || DeviceType.IS_IPHONE_6P {
            self.page2.addConstraint(NSLayoutConstraint(item: layer_center, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50))
        }else{
            self.page2.addConstraint(NSLayoutConstraint(item: layer_center, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20))
        }
        // Center Weather Icon Constrain
        ivWeatherIcon.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:62))
        ivWeatherIcon.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:62))
        
        // layer_center Contraint
        layer_center.addConstraint(NSLayoutConstraint(item: self.layer_center, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 282))
        layer_center.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: ivWeatherIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_center, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: lbTodayWeather, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem:layer_center , attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        layer_center.addConstraint(NSLayoutConstraint(item: lbTodayWeather, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: ivWeatherIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -1))
        
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
    
    // MARK: - Change Publis Timer
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
        lbUpdateTime.text = center.s2t(tip)
        
    }
}

//                ivLabelBackground.hidden = false
extension ViewController:PassValueDelegate{
    func setValue(dict: NSDictionary) {
        let from:String = dict.valueForKey("from") as! String
        if from == "city"{
            let city_display:String = (dict.valueForKey("city_display_name") as! String)
            if city_display != "" {
                self.lbLocation.text = city_display
                self.lbPage2Location.text = city_display
                
                isClockSetup = false
                isChartSetup = false
                self.center.start(updateViews: {
                    //                    self.updateView()
                })
            }
        }
    }
}

// MARK: - Pull to Refresh Task  000
//func refreshTask(refreshC:UIRefreshControl){
//    //        refreshC.attributedTitle = NSAttributedString(string: "Refreshing data...")
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
//        //            NSThread.sleepForTimeInterval(3)
//        
//        dispatch_async(dispatch_get_main_queue(),{
//            self.center.start(updateViews: {
//                self.updateView()
//                refreshC.endRefreshing()
//            })
//        })
//    })
//}
extension ViewController : SSPullToRefreshViewDelegate{
    func pullToRefreshViewDidStartLoading(view: SSPullToRefreshView!) {
        self.ptf.startLoading()
        self.center.start(updateViews: {
//                        self.updateView()
            //finishLoadingAnimated(true, completion: nil)
        })
        self.ptf.finishLoading()
    }
    func pullToRefreshViewShouldStartLoading(view: SSPullToRefreshView!) -> Bool {
        var cv = (self.ptf.contentView as! UIPtfView).updateTime
        if cv == nil {
            return true
        }
        
        let elapsedTime = NSDate().timeIntervalSinceDate(cv!)
        
        if elapsedTime < 3.0 {
            self.view.makeToast(message: center.s2t("别刷了，刷碗都没见你这么积极！")!, duration: 3, position: "top")
            return false
        }
        
        return true
    }
    
}



