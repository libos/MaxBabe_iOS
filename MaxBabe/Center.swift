//
//  Center.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

struct Chosen{
    var id:Int?
    var comment:String?
    var path:String?
    var md5:String?
}
class Center :NSObject{
    let database:FMDatabase!
    let isAlreadyInit : Bool = false
    let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    let converter:NCChineseConverter = NCChineseConverter.sharedInstance()
    let default_lang: AnyObject?  = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages")?.objectAtIndex(0)
    class var getInstance:Center {
        
        struct Singleton {
            static let instance = Center()
        }
        return Singleton.instance
    }
    
    override init() {
        let path = documentsFolder.stringByAppendingPathComponent("com.maxtain.maxbabe.sqlite")
        let storeURL:NSURL  = NSURL.fileURLWithPath(path)!
        if !NSFileManager.defaultManager().fileExistsAtPath(storeURL.path!){
            let preloadURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("com.maxtain.maxbabe", ofType: "sqlite")!)
            
            let err : NSErrorPointer = NSErrorPointer()
            if !NSFileManager.defaultManager().copyItemAtURL(preloadURL!, toURL: storeURL, error: err)
            {
                println("Oops, could copy preloaded data")
            }
        }
        println(storeURL.path!)
        database = FMDatabase(path: storeURL.path)
        if !database.open() {
            println("Unable to open database")
         
        }

        if let rs = database.executeQuery("select * from background", withArgumentsInArray: nil) {
            while rs.next() {
                let x = rs.stringForColumn("filename")
                let y = rs.stringForColumn("path")
                let z = rs.stringForColumn("md5")
                println("x = \(x); y = \(y); z = \(z)")
            }
        } else {
            println("select failed: \(database.lastErrorMessage())")
        }
        super.init()
    }
    
    func s2t(ori:String) -> String{
        if  isTwChinese(){
            return converter.convert(ori, withDict: NCChineseConverterDictTypezh2TW)
        }else{
            return ori
        }
        
    }
    
    func isTwChinese()->Bool{
        if default_lang!.isEqualToString("zh-Hant") {
            return true
        }else{
            return false
        }
    }
    
    
    
//    
//    bool  LanguageManager::isTaiWanChinese()
//    {
//    // get the current language and country config
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//    NSString *currentLanguage = [languages objectAtIndex:0];
//    
//    if ( [currentLanguage isEqualToString:@"zh-Hant"])
//    {
//    return  true;
//    }
//    else
//    {
//    return  false;
//    }
//    
//    }
    
    
    
    
    
    
    func exist(path : String) ->Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func getPath(filename:String) -> String
    {
        
        let path = documentsFolder.stringByAppendingPathComponent(filename)
        if exist(path) {
            return path
        }

        var isDir = ObjCBool(false)
        if !NSFileManager.defaultManager().fileExistsAtPath(path.stringByDeletingLastPathComponent, isDirectory: &isDir){
            NSFileManager.defaultManager().createDirectoryAtPath(path.stringByDeletingLastPathComponent, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        
        return path
        
//        [[NSFileManager defaultManager createDirectoryAtPath:[storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
//            
//            NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)]
    }
    
    func init_db(){
        if !database.executeUpdate(Global.create_background_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        if !database.executeUpdate(Global.create_figure_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        if !database.executeUpdate(Global.create_oneword_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        if !database.executeUpdate(Global.create_city_table, withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        
    }
    
    
    func insert_into()
    {
        //        if !database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", withArgumentsInArray: ["a", "b", "c"]) {
        //            println("insert 1 table failed: \(database.lastErrorMessage())")
        //        }
        //
        //        if !database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", withArgumentsInArray: ["e", "f", "g"]) {
        //            println("insert 2 table failed: \(database.lastErrorMessage())")
        //        }
        
        
//        if let rs = database.executeQuery("select x, y, z from test", withArgumentsInArray: nil) {
//            while rs.next() {
//                let x = rs.stringForColumn("x")
//                let y = rs.stringForColumn("y")
//                let z = rs.stringForColumn("z")
//                println("x = \(x); y = \(y); z = \(z)")
//            }
//        } else {
//            println("select failed: \(database.lastErrorMessage())")
//        }

    }
    
    let pendingOperations = PendingOperations()
    func start(#updateViews:()->()){
        let downloader = WeatherDownloader()
        downloader.completionBlock = {
            if downloader.cancelled{
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                updateViews()
            })
        }
        pendingOperations.imagesQueue.addOperation(downloader)
    }

    func waitForWeather(#updateViews:()->()){
        let idle = IdleOperation()
        idle.completionBlock = {
            if idle.cancelled {
                return 
            }
            dispatch_async(dispatch_get_main_queue(), {
                updateViews()
            })
        }
        pendingOperations.idleQueue.addOperation(idle)
    }
    func start(){
        self.start(updateViews: {})
    }

    func open(){
        if !database.open() {
            println("Unable to open database")
        }
    }
    func close(){
        if database.isAccessibilityElement {
            database.close()
        }
    }
    
    
}