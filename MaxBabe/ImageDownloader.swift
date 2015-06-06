//
//  ImageDownloader.swift
//  MaxBabe
//
//  Created by Liber on 6/1/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation
enum ImageType{
    case Background,Figure
}

class ImageDownloader: NSOperation {
    let url:String!
    let type:ImageType!
    let id:Int!
    let center = Center.getInstance
    let md5:String!
    let storePath:String!
    var sqliteRetPath:String!
    var cancel_flag:Bool = false
    
    init(url:String,md5:String,id:Int){
        self.url = url
        self.id = id
        if url.contains("figure"){
            self.type = .Figure
        }else{
            self.type = .Background
        }
        self.md5 = md5
        if self.type == .Figure {
            sqliteRetPath = "figures/\(md5).\(url.pathExtension)"
            storePath = center.getPath(sqliteRetPath)
            if center.exist(storePath){
                Figure.updateAfterDownload(self.id, path: sqliteRetPath)
                cancel_flag = true
            }
        }else if self.type == .Background {
            sqliteRetPath = "backgrounds/\(md5).\(url.pathExtension)"
            storePath = center.getPath(sqliteRetPath)
            if center.exist(storePath){
                Background.updateAfterDownload(self.id, path: sqliteRetPath)
                cancel_flag = true
            }
        }else{
            storePath = ""
            cancel_flag = true
        }

    }
    
    override func main() {
        if self.cancel_flag {
            return
        }
        if self.cancelled{
            return
        }
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFImageResponseSerializer()
        manager.GET(self.url, parameters: nil, success: { (opt:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            
            let image = response as! UIImage!
            UIImagePNGRepresentation(image).writeToFile(self.storePath, atomically: true)
            
            },failure: { (opt:AFHTTPRequestOperation!, err:NSError!) -> Void in
                println(err.localizedDescription)
                return
            }
        )

        if self.cancelled{
            return
        }
        
    }   
}