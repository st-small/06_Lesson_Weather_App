//
//  WeatherData.swift
//  06_Lesson_Weather_App
//
//  Created by Stanly Shiyanovskiy on 14.12.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherData: Object {
    dynamic var city_name: String = ""
    var tempList = List<DataModel>()
    
    override static func primaryKey() -> String? {
        return "city_name"
    }
    
}
