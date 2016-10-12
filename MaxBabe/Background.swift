//
//  Background.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation


class Background {
    var bid : String?
    var background : String?
    var bmd5 : String?
    var bweather : String?
    var bgehour : String?
    var blehour : String?
    var bgemonth : String?
    var blemonth : String?
    var bgeweek : String?
    var bleweek : String?
    var bgetemp : String?
    var bletemp : String?
    var bgeaqi : String?
    var bleaqi : String?
    var bupdate : String?
    let database:FMDatabase =  Center.getInstance.database!
    
    let pendingOperations = PendingOperations()
    let baseURL = "http://cdn-babe-img.maxtain.com"
    
    init()
    {
        
    }
    
    func save(){
        if !self.hasSelf() {
            if !database.executeUpdate("insert into background (id, bid, filename, path, md5, download, weather, ge_hour, le_hour, ge_week, le_week, ge_month, le_month, ge_temp, le_temp,  ge_aqi, le_aqi) values (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  ?, ?)", withArgumentsInArray: [self.bid!.toInt()!,self.background!,self.bmd5!,1,self.bweather!.toInt()!,self.bgehour!.toInt()!,self.blehour!.toInt()!,self.bgeweek!.toInt()!,self.bleweek!.toInt()!,self.bgemonth!.toInt()!,self.blemonth!.toInt()!,self.bgetemp!.toInt()!,self.bletemp!.toInt()!,self.bgeaqi!.toInt()!,self.bleaqi!.toInt()!]) {
                
                println("insert 2 table failed: \(database.lastErrorMessage())")
            }
            
            //download image data
            //update image download status use bid
            //
        }
    }
    func save_nofile(){
        if !self.hasSelf() {
            if !database.executeUpdate("insert into background (id, bid, filename, path,md5, download, weather, ge_hour, le_hour, ge_week, le_week, ge_month, le_month, ge_temp, le_temp,  ge_aqi, le_aqi) values (NULL,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  ?, ?)", withArgumentsInArray: [self.bid!.toInt()!,self.background!,"",self.bmd5!,0,self.bweather!,self.bgehour!.toInt()!,self.blehour!.toInt()!,self.bgeweek!.toInt()!,self.bleweek!.toInt()!,self.bgemonth!.toInt()!,self.blemonth!.toInt()!,self.bgetemp!.toInt()!,self.bletemp!.toInt()!,self.bgeaqi!.toInt()!,self.bleaqi!.toInt()!]) {
                
                println("insert background table failed: \(database.lastErrorMessage())")
            }
            startDownload()
            
            //download image data
            //update image download status use bid
            //
        }
    }

    func startDownload(){
        let downloader = ImageDownloader(url: "\(baseURL)\(self.background!)", md5: self.bmd5!, id: self.bid!.toInt()!)
        downloader.completionBlock = {
            if downloader.cancelled{
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                Background.updateAfterDownload(self.bid!.toInt()!, path: downloader.sqliteRetPath)
            })
        }
        pendingOperations.imagesQueue.addOperation(downloader)
    }
    
    func hasSelf() -> Bool{
        if let rs = database.executeQuery("select count(*) from background where bid = ? and download=1", withArgumentsInArray: [self.bid!]) {
            if rs.next(){
                var totalCount:Int32 = rs.intForColumnIndex(0)
//                println("TotalCount:\(totalCount)\n");
                if totalCount > 0{
                    return true
                }else{
                    return false
                }
            }
        } else {
            println("select failed: \(database.lastErrorMessage())")
            return false
        }

        return false;
    }
    
    static func select(filter:String) -> [Chosen]{
        let database:FMDatabase =  Center.getInstance.database!
        
        var list:[Chosen] = []
        if let rs = database.executeQuery("select bid,filename,path,md5 from background where download=1 and \(filter)", withArgumentsInArray: nil) {
            while rs.next() {
                let b = rs.stringForColumn("bid")
                let x = rs.stringForColumn("filename")
                let y = rs.stringForColumn("path")
                let z = rs.stringForColumn("md5")
                list.append(Chosen(id: b.toInt(), comment: x, path: y, md5: z))
//                println("x = \(x); y = \(y); z = \(z)")
            }
        } else {
            println("select failed: \(database.lastErrorMessage())")
        }
        return list
    }
    
    static func getOne() -> Chosen?{
        let wea = Weather.getInstance
        let list = Background.select(wea.nowFilter())
        if list.isEmpty {
            return nil
        }else{
            let idx = Int(arc4random_uniform(UInt32(list.count)))
            
            let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            st.setInteger(list[idx].id!, forKey: Global.cb_id)
            st.setObject(list[idx].path!, forKey: Global.cb_path)
            st.setObject(list[idx].comment!, forKey: Global.cb_filename)
            st.setObject(list[idx].md5!, forKey: Global.cb_md5)
            st.synchronize()
            return list[idx]
        }
    }
    
    static func updateAfterDownload(bid:Int,path:String) -> Bool{
        let database:FMDatabase =  Center.getInstance.database!
        if !database.executeUpdate("update background set path=?,download=1 where bid=?", withArgumentsInArray: [path,bid]){
            println("update background failed:\(bid) \(path) \(database.lastErrorMessage())")
            return false
        }
        return true
    }
}