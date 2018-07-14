//
//  MeteoController.swift
//  Meteo
//
//  Created by yohan Fairfort on 14/07/2018.
//  Copyright © 2018 yohan Fairfort. All rights reserved.
//

import Foundation

import UIKit

class MeteoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Implementing URLSession
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=Paris,fr&APPID=a43ee151d184bc5a3a47cbdf11e483a2"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let articlesData = try JSONDecoder().decode(.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    //print(articlesData)
                    self.articles = articlesData
                    self.collectionView?.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
