//
//  SelectCityViewController.swift
//  06_Lesson_Weather_App
//
//  Created by Stanly Shiyanovskiy on 13.12.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

final class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var citiesArray: [String] = []
    var citiesSet: Set <String> = ["Kiev", "Moscow", "London"]
    let manager: ComplexManager = ComplexManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Выбор города:"
        
        // delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.citiesArray = self.citiesSet.map ({ String($0) })
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
        
        openViewController(city: citiesArray[indexPath.row])
        
        //print("You tapped cell number \(citiesArray[indexPath.row]).")
    }
    
    // methods to delete rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            citiesArray.remove(at: indexPath.row)
            tableView.reloadData()
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
                                        
                                        for i in self.citiesArray {
                                            
                                            if i == city {
                                                
                                                print("уже есть")
                                                
                                            } else {
                                                
                                                self.citiesSet.insert(city!)
                                                
                                            }
                                            
                                            self.citiesArray = self.citiesSet.map ({ String($0) })
                                            self.tableView.reloadData()
                                            
                                            self.openViewController(city: city!)
                                            
                                        }}))
                                        
        self.present(alertCT, animated: true, completion: nil)
    }
    
    func openViewController(city: String) {
        
        let destVC: DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        destVC.city_name = city
        self.present(destVC, animated: true, completion: nil)
    }
    
}


extension SelectCityViewController {
    
    
}
