//
//  IdleOperation.swift
//  MaxBabe
//
//  Created by Liber on 6/4/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class IdleOperation : NSOperation {
    let weather:Weather
    
    override init(){
        weather = Weather.getInstance
        super.init()
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        while weather.state != Weather.WeatherState.Stored{
//            println("test")
        }
        if self.cancelled {
            return
        }
    }
    
}