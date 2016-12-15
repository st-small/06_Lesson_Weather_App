//
//  HistoryTable.swift
//  06_Lesson_Weather_App
//
//  Created by Stanly Shiyanovskiy on 14.12.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class HistoryTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    let realm = try! Realm()
    var city: String = ""
    var tempArray: [DataModel] = []
    var weather: DataModel = DataModel()
    
    let manager: ComplexManager = ComplexManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "История запросов:"

        tableView.delegate = self
        tableView.dataSource = self
        
        let dataDB = manager.loadCityDB(city: city)
        
        for tmp in dataDB[0].tempList {
            
            self.weather = tmp
            
            tempArray.append(self.weather)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MyCustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! MyCustomCell
        let weather = tempArray[indexPath.row]
        let temp = String(format: "%.1f °C", weather.temp)
        
        cell.myCellLabel?.text = "\(weather.location), \(temp), \(makeDate(dt: weather.date)), \(weather.weather)"
        cell.myView?.image = UIImage(named: weather.weatherImg)
        
        return cell
    }
    
    func makeDate(dt: Double) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: dt)
        return "\(dateFormatter.string(from: date))"
    }
    
}
