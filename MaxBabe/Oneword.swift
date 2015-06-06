//
//  Oneword.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class Oneword
{
    var oid : String?
    var words : String?
    var oweather : String?
    var ogehour : String?
    var olehour : String?
    var ogemonth : String?
    var olemonth : String?
    var ogeweek : String?
    var oleweek : String?
    var ogetemp : String?
    var oletemp : String?
    var ogeaqi : String?
    var oleaqi : String?
    var oupdate : String?
    let database:FMDatabase = Center.getInstance.database!

    init(){
        
    }
    func save(){
        if !self.hasSelf(){
            if !database.executeUpdate("insert into oneword (id, oid, word, weather, ge_hour, le_hour, ge_week, le_week, ge_month, le_month, ge_temp, le_temp,  ge_aqi, le_aqi) values (NULL,?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)", withArgumentsInArray: [self.oid!.toInt()!,self.words!,self.oweather!,self.ogehour!.toInt()!,self.olehour!.toInt()!,self.ogemonth!.toInt()!,self.olemonth!.toInt()!,self.ogeweek!.toInt()!,self.oleweek!.toInt()!,self.ogetemp!.toInt()!,self.oletemp!.toInt()!,self.ogeaqi!.toInt()!,self.oleaqi!.toInt()!]) {
                
                println("insert 2 table failed: \(database.lastErrorMessage())")
                
            }
        }
    }
    
    func hasSelf() -> Bool{
        if let rs = database.executeQuery("select count(*) from oneword where oid = ?", withArgumentsInArray: [self.oid!]) {
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
    
    
    
    static func select(filter:String) -> [Chosen]{
        let database:FMDatabase =  Center.getInstance.database!
        
        var list:[Chosen] = []
        if let rs = database.executeQuery("select oid,word from oneword where \(filter)", withArgumentsInArray: nil) {
            while rs.next() {
                let b = rs.stringForColumn("oid")
                var x:String = rs.stringForColumn("word")
                
                
                if let range = x.rangeOfString("<br>") {
                    let start = advance(x.startIndex, distance(x.startIndex,range.startIndex))
                    let end = advance(x.startIndex, distance(x.startIndex,range.endIndex))
                    
                    x = x.stringByReplacingCharactersInRange(start..<end, withString: "\n")
                    x = x.stringByReplacingOccurrencesOfString("<br>", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
                list.append(Chosen(id: b.toInt(), comment: x, path: "", md5: ""))
                println("x = \(x);b= \(b);")
            }
        } else {
            println("select failed: \(database.lastErrorMessage())")
        }
        return list
    }
    
    static func getOne() -> Chosen?{
        let wea = Weather.getInstance
        let list = Oneword.select(wea.nowFilter())
        if list.isEmpty {
            return nil
        }else{
            let idx = Int(arc4random_uniform(UInt32(list.count)))
            let st:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            st.setInteger(list[idx].id!, forKey: Global.co_id)
            st.setObject(list[idx].comment!, forKey: Global.co_word)
            st.synchronize()
            return list[idx]
        }
    }

}