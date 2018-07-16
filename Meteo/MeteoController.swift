//
//  MeteoController.swift
//  Meteo
//
//  Created by yohan Fairfort on 14/07/2018.
//  Copyright © 2018 yohan Fairfort. All rights reserved.
//

import Foundation

import UIKit

class MeteoController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ForeCastDt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCellIdentifier") as! CustomForecastCell
        
        let textDegree = ForeCastDt[indexPath.row].main!.temp!
        let textDate = ForeCastDt[indexPath.row].dt!
        let textWeather = ForeCastDt[indexPath.row].weather![0].description!

        cell.Degree.text = String(textDegree) + "°C"
        cell.Date.text = getLocalDate(textDate, format: "dd MMMM")
        cell.Weather.text = textWeather

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBOutlet weak var Ville: UILabel!
    @IBOutlet weak var Degre: UILabel!
    @IBOutlet weak var Temps: UILabel!
    @IBOutlet weak var Sunrise: UILabel!
    @IBOutlet weak var Sunset: UILabel!
    @IBOutlet weak var ForecastTitle: UILabel!
    @IBOutlet weak var ForecastTableView: UITableView!
    
    var ForeCastDt: [List] = []

    fileprivate func setBasicWeather(_ url: URL) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(Meteo.self, from: data)
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.Ville.text = responseModel.name
                    self.Degre.text = String(format:"%.1f", responseModel.main!.temp!) + "°C"
                    self.Temps.text = responseModel.weather?[0].description
                    self.Sunrise.text = "The sunrise will happen at " + self.getLocalDate(responseModel.sys!.sunrise!, format: "hh:mm")
                    self.Sunset.text = "The sunset will happen at " + self.getLocalDate(responseModel.sys!.sunset!, format: "hh:mm")
                    //self.collectionView?.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
    
    fileprivate func setForecastWeather(_ url: URL) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(Forecast.self, from: data)
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.ForeCastDt = responseModel.list!
                    
                    self.ForecastTableView?.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ForecastTableView.dataSource = self
        self.ForecastTitle.text = "Forecast"
        //Implementing URLSession
        let urlBasicString = "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr&units=metric&APPID=a43ee151d184bc5a3a47cbdf11e483a2"
        guard let basicUrl = URL(string: urlBasicString) else { return }
        let setBasicTask = setBasicWeather(basicUrl)
        
        let urlForecastString = "http://api.openweathermap.org/data/2.5/forecast?q=Paris,fr&units=metric&APPID=a43ee151d184bc5a3a47cbdf11e483a2"
        guard let forecastUrl = URL(string: urlForecastString) else { return }
        let setForecastTask = setForecastWeather(forecastUrl)
        
        setForecastTask.resume()
        setBasicTask.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getLocalDate(_ rawDate :Int, format :String) -> String {
        let date = Date(timeIntervalSince1970: Double(rawDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
