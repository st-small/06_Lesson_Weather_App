//
//  DataModel.swift
//  06_Lesson_Weather_App
//
//  Created by Stanly Shiyanovskiy on 14.12.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

final class DataModel: Object {
    
    dynamic var date: Double = 0
    dynamic var temp: Double = 0
    dynamic var location: String = ""
    dynamic var weather: String = ""
    dynamic var weatherImg: String = ""
    
}
