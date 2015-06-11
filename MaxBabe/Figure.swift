//
//  Figure.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation


class Figure
{
    var fid : String?
    var figure : String?
    var fmd5 : String?
    var fweather : String?
    var fgehour : String?
    var flehour : String?
    var fgemonth : String?
    var flemonth : String?
    var fgeweek : String?
    var fleweek : String?
    var fgetemp : String?
    var fletemp : String?
    var fgeaqi : String?
    var fleaqi : String?
    var fupdate : String?
    let database:FMDatabase = Center.getInstance.database!
    
    let pendingOperations = PendingOperations()
    let baseURL = "http://cdn-babe-img.maxtain.com"
    
    init(){
        
    }
    
    func save(){
        if  !self.hasSelf() {
            if !database.executeUpdate("insert into figure (id,fid, filename, path, md5, download, weather, ge_hour, le_hour, ge_week, le_week, ge_month, le_month, ge_temp, le_temp,  ge_aqi, le_aqi) values (NULL,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  ?, ?)", withArgumentsInArray: [self.fid!.toInt()!,self.figure!,self.fmd5!,1,self.fweather!,self.fgehour!.toInt()!,self.flehour!.toInt()!,self.fgemonth!.toInt()!,self.flemonth!.toInt()!,self.fgeweek!.toInt()!,self.fleweek!.toInt()!,self.fgetemp!.toInt()!,self.fletemp!.toInt()!,self.fgeaqi!.toInt()!,self.fleaqi!.toInt()!]) {
                
                println("insert 2 table failed: \(database.lastErrorMessage())")
                
            }
        }
    }
    func save_nofile(){
        if  !self.hasSelf() {
            if !database.executeUpdate("insert into figure (id,fid,filename, path, md5, download, weather, ge_hour, le_hour, ge_week, le_week, ge_month, le_month, ge_temp, le_temp,  ge_aqi, le_aqi) values (NULL,?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  ?, ?)", withArgumentsInArray: [self.fid!,self.figure!,"",self.fmd5!,0,self.fweather!,self.fgehour!.toInt()!,self.flehour!.toInt()!,self.fgemonth!.toInt()!,self.flemonth!.toInt()!,self.fgeweek!.toInt()!,self.fleweek!.toInt()!,self.fgetemp!.toInt()!,self.fletemp!.toInt()!,self.fgeaqi!.toInt()!,self.fleaqi!.toInt()!]) {
                
                println("insert figure table failed: \(database.lastErrorMessage())")
                
            }
            startDownloadImage()
            
        }
    }
    
    func startDownloadImage(){
        let downloader = ImageDownloader(url: "\(baseURL)\(self.figure!)", md5: self.fmd5!, id: self.fid!.toInt()!)
        downloader.completionBlock = {
            if downloader.cancelled{
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                Figure.updateAfterDownload(self.fid!.toInt()!, path: downloader.sqliteRetPath)
            })
        }
        pendingOperations.imagesQueue.addOperation(downloader)
    }
    
    
    func hasSelf() -> Bool{
        if let rs = database.executeQuery("select count(*) from figure where fid = ?", withArgumentsInArray: [self.fid!]) {
            if rs.next(){
                var totalCount:Int32 = rs.intForColumnIndex(0)
                
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
    
    static func updateAfterDownload(fid:Int,path:String) -> Bool{
        let database:FMDatabase =  Center.getInstance.database!
        if !database.executeUpdate("update figure set path=?,download=1 where fid=?", withArgumentsInArray: [path,fid]){
            println("update figure failed:\(fid) \(path) \(database.lastErrorMessage())")
            return false
        }
        return true
    }
    
    
    static func select(filter:String) -> [Chosen]{
        let database:FMDatabase =  Center.getInstance.database!
        
        var list:[Chosen] = []
        if let rs = database.executeQuery("select fid,filename,path,md5 from figure where download=1 and \(filter)", withArgumentsInArray: nil) {
            while rs.next() {
                let b = rs.stringForColumn("fid")
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
        let list = Figure.select(wea.nowFilter())
        if list.isEmpty {
            return nil
        }else{
            let idx = Int(arc4random_uniform(UInt32(list.count)))
            let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            st.setInteger(list[idx].id!, forKey: Global.cf_id)
            st.setObject(list[idx].path!, forKey: Global.cf_path)
            st.setObject(list[idx].comment!, forKey: Global.cf_filename)
            st.setObject(list[idx].md5!, forKey: Global.cf_md5)
            st.synchronize()
            return list[idx]
        }
    }
    
}