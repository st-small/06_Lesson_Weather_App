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
    
    var citiesArray: [String] = ["Kiev", "Moscow", "London"]
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
            
            self.citiesSet.insert(tmp.city_name)
            //print(tmp.city_name)
        }
        
        self.citiesArray = self.citiesSet.sorted()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
            citiesSet.remove(city)
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
                                        
                                        if !self.citiesSet.contains(city!) {
                                                
                                                self.citiesSet.insert(city!)
                                                //print(self.citiesArray.count)
                                            }
                                        
                                        self.citiesArray.removeAll()
                                        self.citiesArray = self.citiesSet.sorted()
                                        
                                        self.tableView.reloadData()
                                            
                                        }))
                                        
        self.present(alertCT, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destVC: DetailViewController = segue.destination as! DetailViewController
                destVC.city_name = self.citiesArray[indexPath.row]
            }
        }
    }
    
}

