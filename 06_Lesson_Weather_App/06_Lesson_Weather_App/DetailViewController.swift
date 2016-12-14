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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        //self.weather = manager.fetchingData()
        
        let manager: ComplexManager = ComplexManager()
        let downloadJSON = manager.loadCityDB(city: city_name)
        
        print("JSON", downloadJSON)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.updateUI()
        })
        
        if downloadJSON[0].tempList.count > 0 {
            
            self.weather = downloadJSON[0].tempList[0]
            print("JSON", downloadJSON)
        
        }
        
        print("пусто пусто пусто")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.updateUI()
        
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
