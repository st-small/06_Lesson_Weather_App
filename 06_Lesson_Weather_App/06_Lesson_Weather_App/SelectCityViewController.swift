//
//  SelectCityViewController.swift
//  06_Lesson_Weather_App
//
//  Created by Stanly Shiyanovskiy on 13.12.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    
    var citiesArray: [String] = []
    var citiesSet: Set <String> = ["Kiev", "Moscow", "London"]
    let manager: ComplexManager = ComplexManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Выбор города:"
        
        // delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        let dataBase = manager.loadDB()
        
        for tmp in dataBase {
            
            self.citiesArray.append(tmp.city_name)
            //print(tmp.city_name)
        }
        
        self.citiesArray = self.citiesArray.sorted()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    // size of row's height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77.0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! MyCustomCell
        cell.myCellLabel?.text = "\(citiesArray[indexPath.row])"
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.openViewController(city: self.citiesArray[indexPath.row])
        
    }
    
    // methods to delete rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let city = citiesArray[indexPath.row]
            let dataByCity = manager.loadCityDB(city: city)
            
            try! realm.write {
                realm.delete(dataByCity)
            }
            
            citiesArray.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
   
    @IBAction func addCityAction(_ sender: UIBarButtonItem) {

        
        let alertCT = UIAlertController(title: "Добавить город:",
                                      message: "Введите Ваш город латинскими буквами",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alertCT.addTextField { (city: UITextField) in
            city.placeholder = "Ваш город"
            city.keyboardType = UIKeyboardType.namePhonePad
        }
        
        alertCT.addAction(UIAlertAction(title: "Добавить",
                                      style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                                        
                                        let city = alertCT.textFields![0].text?.capitalized
                                        
                                        if !self.citiesArray.contains(city!) {
                                                
                                                self.citiesArray.append(city!)
                                                print(self.citiesArray.count)
                                            }
                                            
                                            self.tableView.reloadData()
                                            
                                        }))
                                        
        self.present(alertCT, animated: true, completion: nil)
    }
    
    func openViewController(city: String) {
        
        let destVC: DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        destVC.city_name = city
        self.present(destVC, animated: true, completion: nil)
    }
    
}

