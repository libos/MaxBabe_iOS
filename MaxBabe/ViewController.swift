//
//  ViewController.swift
//  MaxBabe
//
//  Created by Liber on 5/26/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import UIKit
import Darwin

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
    
    
    @IBOutlet weak var ivAqi: UIImageView!
    @IBOutlet weak var lbAqi: UILabel!
    
    
    
    var screenHeight:CGFloat!
    //    var blurredImageView:UIImageView!
    //    var blurredFigureView:UIImageView!
    var detailView:UIScrollView!
    var refreshControl:UIRefreshControl!
    let center:Center = Center.getInstance
    let weather:Weather = Weather.getInstance
    var page2:UIView!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if weather.state != Weather.WeatherState.Stored{
            center.waitForWeather(updateViews: { () -> () in
                self.updateView()
            })
        }else{
            self.updateView()
        }
        
        
        //        var backpath = Background.getOne()!.path!
        //        if NSFileManager.defaultManager().fileExistsAtPath(backpath){
        //
        //        }
        
        //        let backimg:UIImage = UIImage(named: "splash")!
        
        // TODO
        self.screenHeight =  UIScreen.mainScreen().bounds.size.height
        
        let aTimer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(100.0, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
        aTimer.fire()
        
        //        self.blurredImageView = UIImageView()
        //        self.blurredImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //        self.blurredImageView.alpha = 0
        //        self.blurredImageView.setImageToBlur(self.mBackground.image, blurRadius: 10, completionBlock: nil)
        //        self.blurredImageView.hidden = true
        //        self.view.addSubview(self.blurredImageView)
        
        //        self.blurredFigureView = UIImageView()
        //        self.blurredFigureView.contentMode = UIViewContentMode.ScaleAspectFit
        //        self.blurredFigureView.alpha = 0
        //        self.blurredFigureView.setImageToBlur(self.mFigure.image, blurRadius: 100, completionBlock: nil)
        //        self.blurredFigureView.hidden = true
        //        self.view.addSubview(self.blurredFigureView)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "testRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        self.detailView = UIScrollView(frame: self.view.bounds)
        self.detailView.contentSize = CGSizeMake(self.detailView.frame.size.width,self.detailView.frame.size.height*2)
        self.detailView.backgroundColor = UIColor.clearColor()//UIColor(white: 0, alpha: 0.8)
        self.detailView.delegate = self
        self.detailView.pagingEnabled = true
        self.detailView.scrollEnabled = true
        self.detailView.addSubview(self.refreshControl)
        
        self.view.addSubview(self.detailView)
        
        let nextFrame = UIScreen.mainScreen().bounds
        let inset:CGFloat = 20
        
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
        
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: now)
        var hour =  components.hour
        var arr_list = Global.arr_morning
        if hour > 12 {
            hour = hour - 12
            arr_list = Global.arr_afternoon
        }
        
        ivLabelBackground = UIImageView(image: UIImage(named: "white_block17"))
        ivLabelBackground.layer.cornerRadius = ivLabelBackground.frame.size.width/2
        ivLabelBackground.clipsToBounds = true
        ivLabelBackground.setTranslatesAutoresizingMaskIntoConstraints(false)
        layer_number_back.addSubview(ivLabelBackground)
        
        ivLabelBackground.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:17))
        ivLabelBackground.addConstraint(NSLayoutConstraint(item: ivLabelBackground, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:17))
//        if hour == 12 {
//            layer_number_back.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_dots, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//            layer_number_back.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_dots, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -100))
//        }else{
//            var horizon =  CGFloat(round(100 * sin( Double(idx) * Double(M_PI) / Double(6.0) )))
//            var vertical = CGFloat(round(100 - (100 * cos(Double(idx) * Double(M_PI) / Double(6.0)) )))
//            layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: ivDots[0], attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: horizon ))
//            layer_dots.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: ivDots[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: vertical))
//        }

        
        
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
            if idx == 12 {
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
            
            
            var icon = UIImageView(image: UIImage(named: "icon_home_weather_daytime_cloudy01"))
            icon.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_icons.addSubview(icon)
            icon.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:31))
            icon.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:31))
            if idx == 12 {
                layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: layer_icons, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: layer_icons, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -120))
            }else{
                var horizon =  CGFloat(round(120 * sin( Double(idx) * Double(M_PI) / Double(6.0) )))
                var vertical = CGFloat(round(120 - (120 * cos(Double(idx) * Double(M_PI) / Double(6.0)) )))
                layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: icon_weathers[0], attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: horizon ))
                layer_icons.addConstraint(NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: icon_weathers[0], attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: vertical))
            }
            icon_weathers.append(icon)
            
            
            var dot = UIImageView(image: UIImage(named: "white_block"))
            dot.layer.cornerRadius = dot.frame.size.width/2
            dot.clipsToBounds = true
            dot.setTranslatesAutoresizingMaskIntoConstraints(false)
            layer_dots.addSubview(dot)
            
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:5))
            dot.addConstraint(NSLayoutConstraint(item: dot, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant:5))
            if idx == 12 {
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
        
        


        
        
        layer_center.addSubview(ivWeatherIcon)
        layer_center.addSubview(lbTodayWeather)
        
        layer_center.addSubview(layer_number_back)
        layer_center.addSubview(layer_number)
        layer_center.addSubview(layer_dots)
        layer_center.addSubview(layer_icons)
        
        self.page2.addSubview(layer_center)
        

        
        // Page2 Constraint:frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width, height: 282)
        // x y
//        self.detailView.addConstraint(NSLayoutConstraint(item: self.page2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
//        self.detailView.addConstraint(NSLayoutConstraint(item: self.page2, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.detailView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        // Width Height
//        self.page2.addConstraint(NSLayoutConstraint(item: self.page2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: screenHeight))
//        self.page2.addConstraint(NSLayoutConstraint(item: self.page2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.page2, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: self.view.bounds.size.width))
        
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
        

        
//        clock_layers = [layer_center,layer_number,layer_dots,layer_icons]
        
        //        CGRect headerFrame = [UIScreen mainScreen].bounds;
        //        CGFloat inset = 20;
        //        CGFloat temperatureHeight = 110;
        //        CGFloat hiloHeight = 40;
        //        CGFloat iconHeight = 30;
        //        CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight, headerFrame.size.width - 2*inset, hiloHeight);
        //        CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - temperatureHeight - hiloHeight, headerFrame.size.width - 2*inset, temperatureHeight);
        //        CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
        //        CGRect conditionsFrame = iconFrame;
        //        // make the conditions text a little smaller than the view
        //        // and to the right of our icon
        //        conditionsFrame.size.width = self.view.bounds.size.width - 2*inset - iconHeight - 10;
        //        conditionsFrame.origin.x = iconFrame.origin.x + iconHeight + 10;
        //
        //        UIView *header = [[UIView alloc] initWithFrame:headerFrame];
        //        header.backgroundColor = [UIColor clearColor];
        //        self.tableView.tableHeaderView = header;
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func testRefresh(refreshC:UIRefreshControl){
        //        refreshC.attributedTitle = NSAttributedString(string: "Refreshing data...")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            //            NSThread.sleepForTimeInterval(3)
            
            dispatch_async(dispatch_get_main_queue(),{
                self.center.start(updateViews: {
                    self.updateView()
                    refreshC.endRefreshing()
                });
            })
        })
    }
    
    func timerFired(timer:NSTimer){
        self.center.start(updateViews: {
            self.updateView()
        });

    }
    
    func updateView(){
        self.mTemp.text = "\(weather.getTemp()!)°"
        self.tvWeather.text = "\(weather.getWeather()!)"
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
                // Log.e("err", data.toString());
                if (aqi <= 50) {
                    aqi_msg = " \(aqi) 超赞";
                    haze_level = 0;
                } else if (aqi > 50 && aqi <= 100) {
                    aqi_msg = " \(aqi) 还不错";
                    haze_level = 1;
                } else if (aqi > 100 && aqi <= 150) {
                    aqi_msg = " \(aqi) 有点差哦";
                    haze_level = 2;
                } else if (aqi > 150 && aqi <= 200) {
                    aqi_msg = " \(aqi) 蛮差的";
                    haze_level = 3;
                } else if (aqi > 200 && aqi <= 300) {
                    aqi_msg = " \(aqi) 别出门了";
                    haze_level = 4;
                } else if (aqi > 300) {
                    aqi_msg = " \(aqi) 已爆表";
                    haze_level = 5;
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
        if let humi = weather.data.humidity {
            self.lbHumi.text = humi
            self.ivWet.hidden = false
            self.lbHumi.hidden = false
        }else{
            self.ivWet.hidden = true
            self.lbHumi.hidden = true
        }
        
        if let wind = weather.data.fenglevel {
            self.lbWind.text = wind
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
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bounds:CGRect = self.view.bounds;
        
        //        self.rootView.frame = bounds;
        //        self.blurredImageView.frame = bounds
        //        self.blurredFigureView.frame = self.mFigure.frame
        //        self.detailView.frame = bounds
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let height:CGFloat = scrollView.bounds.size.height;
        let position:CGFloat = max(scrollView.contentOffset.y, 0.0);
        // 2
        let percent:CGFloat = min(position / height, 1.0);
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
}
