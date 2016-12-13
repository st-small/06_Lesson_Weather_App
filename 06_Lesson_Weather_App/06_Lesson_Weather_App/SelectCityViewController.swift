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
    
    @IBAction func addCityAction(_ sender: Any) {
        
        self.addCity()
    }
    
    var citiesArray: [String] = ["Kiev", "Moscow", "London"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Выбор города:"
        
        // delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
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
        print("You tapped cell number \(indexPath.row).")
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
    
}


extension SelectCityViewController {
    
    func addCity() {
        
        let alert = UIAlertController(title: "Помощник", message: "Для удобного переключения между городами, тапните по экрану!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
