//
//  City.swift
//  MaxBabe
//
//  Created by Liber on 5/31/15.
//  Copyright (c) 2015 Maxtain. All rights reserved.
//

import Foundation

class City {
    var city_name:String?
    var city_code:String?
    var level2:String?
    var province:String?
    var country:String?
    
    
    init(city_name:String,city_code:String,level2:String,province:String,country:String){
        self.city_name  = city_name
        self.city_code = city_code
        self.level2 = level2
        self.province = province
        self.country = country

    }
    
    
}