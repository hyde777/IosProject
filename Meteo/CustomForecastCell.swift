//
//  CustomForecastCell.swift
//  Meteo
//
//  Created by yohan Fairfort on 15/07/2018.
//  Copyright © 2018 yohan Fairfort. All rights reserved.
//

import UIKit

class CustomForecastCell: UITableViewCell {
    @IBOutlet weak var Degree: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Weather: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
