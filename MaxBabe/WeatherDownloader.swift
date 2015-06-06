//
//  WeatherOperation.swift
//  MaxBabe
//
//  Created by Liber on 6/1/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class WeatherDownloader : NSOperation {
    let weather:Weather
    
    override init(){
        weather = Weather.getInstance
        super.init()
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        weather.updateSelf()
        if self.cancelled {
            return
        }
    }
    
}