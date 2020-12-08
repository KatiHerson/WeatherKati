//
//  ViewController.swift
//  Weather5
//
//  Created by user on 23/11/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var currentCityTemp: UILabel!
    @IBOutlet weak var currentCityIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    var array = ["Пермь", "Москва", "Владивосток", "Екатеринбург"]
    var arrCity = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        for cityItem in array {
        setCityArray(name: cityItem)
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getCityDetail(name: "Тюмень")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.nameCity.text = arrCity[indexPath.row].name
        cell.temp.text = arrCity[indexPath.row].temp
        cell.time.text = arrCity[indexPath.row].time
        cell.icon.image = UIImage(data: try! Data(contentsOf: URL(string: arrCity[indexPath.row].icon)!))
        cell.backgroundCell.image = UIImage(data: try! Data(contentsOf: URL(string: "https://1ul.ru/upload/file/publication/sky_1365325_960_720.jpg")!))
         
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func getCityDetail(name: String) {
        let url = "http://api.weatherapi.com/v1/current.json?key=\(token)&q=\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(url as! URLConvertible, method: .get).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.currentCity.text = name
                self.currentCityTemp.text = json["current"]["temp_c"].stringValue
                
                
                let iconString = "https:\(json["current"]["condition"]["icon"].stringValue)"
                self.currentCityIcon.image = UIImage(data: try!  Data(contentsOf: URL(string: iconString)!))
            case .failure(let error):
                print(error)
           }
        }
    }
    
    func setCityArray(name: String) {
        let url = "http://api.weatherapi.com/v1/current.json?key=\(token)&q=\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(url as! URLConvertible, method: .get).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let temp = json["current"]["temp_c"].stringValue
                let city = json["current"]["name"].stringValue
                let icon = "https:\(json["current"]["condition"]["icon"].stringValue)"
                let time = json["location"]["localtime"].stringValue
                self.arrCity.append(City(name: name, temp: temp, icon: icon, time: time))
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
           }
        }
    }
    struct City {
        var name: String
        var temp: String
        var icon: String
        var time: String
    }


}



