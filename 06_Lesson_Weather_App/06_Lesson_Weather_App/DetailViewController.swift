//
//  DetailViewController.swift
//  06_Lesson_Weather_App
//
//  Created by Stanly Shiyanovskiy on 14.12.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var weather = DataModel()
    var city_name : String = ""
    var data : Results<WeatherData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager: ComplexManager = ComplexManager()
        self.data = manager.loadCityDB(city: city_name)
        
        if self.data.count > 0 {
            
            self.weather = self.data[0].tempList.last!
            
        } else {
            
            self.weather = DataModel()
        }
        
        // Define identifier
        let notificationName = Notification.Name("LOAD_FROM_SERVER")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(loadComplete), name: notificationName, object: nil)
        
        self.loadComplete()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func loadComplete() {
        print("NOTIFICATION")
        if self.data.count > 0{
            self.updateUI()
        }else{
            print("EMPTY")
            let alert = UIAlertController(title: "Внимание", message: "У Вас отсутствует доступ к Интернет.\nБаза данных погоды пуста, дождитесь появление Интернета", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateUI() {
        dateLabel.text = makeDate(dt: self.weather.date)
        tempLabel.text = String(format: "%.1f °C", self.weather.temp)
        locationLabel.text = self.weather.location
        weatherLabel.text = self.weather.weather.capitalized
        weatherImage.image = UIImage(named: self.weather.weatherImg)
    }
    
    func makeDate(dt: Double) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: dt)
        return "Сегодня, \(dateFormatter.string(from: date))"
    }
    
    @IBAction func RefreshAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

    
}
