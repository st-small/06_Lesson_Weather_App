//
//  ComplexManager.swift
//  06_Lesson_Weather_App
//
//  Created by Stanly Shiyanovskiy on 14.12.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import SystemConfiguration

class ComplexManager {
    
    static let instance = ComplexManager()
    let tmp: DataModel = DataModel()
    let realm = try! Realm()
    
}

extension ComplexManager {
    
    // Функция обращения к серверу
    func downloadData(town: String) {
        
        let sample = "http://api.openweathermap.org/data/2.5/weather?q=\(town)&appid=a7bbbd5e82c675f805e7ae084f742024&lang=ru"
        let weather: WeatherData = WeatherData()
        
        Alamofire.request(sample).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                weather.city_name = json["name"].stringValue
                //print(json)
                
                self.tmp.date = json["dt"].doubleValue
                self.tmp.temp = json["main"]["temp"].doubleValue - 273.15
                self.tmp.location = "\(json["name"].stringValue), \(json["sys"]["country"].stringValue)"
                self.tmp.weather = json["weather"][0]["description"].stringValue
                self.tmp.weatherImg = json["weather"][0]["main"].stringValue
                print("tmp in JSON", self.tmp)
                
                weather.tempList.append(self.tmp)
                

                try! self.realm.write {
                    self.realm.add(weather, update: true)
                }
                
                let notificationName = Notification.Name("LOADING")
                NotificationCenter.default.post(name: notificationName, object: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadDB() -> Results<WeatherData> {
        let data = realm.objects(WeatherData.self)
        //print(data)
        return data
    }
    
    func loadCityDB(city: String) -> Results<WeatherData> {
        let data = realm.objects(WeatherData.self).filter("city_name  BEGINSWITH %@", city)
        
        //print(data)
        let data2 = realm.objects(DataModel.self).filter("location BEGINSWITH %@", city)
        print(data2)
        
        if data.count > 0 {
            
            return data
            
        } else {
            
            self.downloadData(town: city)
        }
        
        return data
    }
    
    func loadCityHistoryDB(city: String) -> Results<DataModel> {
        
        let data2 = realm.objects(DataModel.self).filter("location BEGINSWITH %@", city)
        print(data2)
        
        if data2.count > 0 {
            
            return data2
            
        } else {
            
            self.downloadData(town: city)
        }
        
        return data2
    }

    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}
