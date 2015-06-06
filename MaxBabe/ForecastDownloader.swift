//
//  ForecastDownload.swift
//  MaxBabe
//
//  Created by Liber on 6/5/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class ForecastDownloader: NSOperation {
    let weather:Weather
    
    override init(){
        weather = Weather.getInstance
        super.init()
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        weather.downloadDaily()
        weather.downloadWeek()
        if self.cancelled {
            return
        }
    }
}