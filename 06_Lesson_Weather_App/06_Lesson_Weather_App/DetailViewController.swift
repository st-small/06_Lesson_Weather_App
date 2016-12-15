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
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let manager: ComplexManager = ComplexManager()
        self.data = manager.loadCityDB(city: city_name)
        
        self.navigationItem.title = city_name
        
        if self.data.count > 0 {
            
            self.weather = self.data[0].tempList.last!
            
        } else {
            
            self.weather = DataModel()
        }
        
        // NotifA
        let notificationName = Notification.Name("LOADING")

        NotificationCenter.default.addObserver(self, selector: #selector(loadComplete), name: notificationName, object: nil)

        loadComplete()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func loadComplete() {
        if self.data.count > 0 {
            self.weather = self.data[0].tempList.last!
            self.updateUI()
            
        } else {
            
            warningAlert(title: "Помощник",
                         message: "Присутствуют перебои с интернет! Мы делаем все возможное!")

        }
    }
    
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
    }
    func warningAlert(title: String, message: String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { (action) -> Void in
        }))
        //   self.present(alert, animated: true, completion: nil)
        presentViewController(alert: alert, animated: true, completion: nil)
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
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openHistoryTableAction(_ sender: UIButton) {
        
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "History" {
            let destVC: HistoryTable = segue.destination as! HistoryTable
            destVC.city = self.city_name
            
        }
    }
}
