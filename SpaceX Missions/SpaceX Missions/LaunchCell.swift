//
//  LaunchCell.swift
//  SpaceX Missions
//
//  Created by Oliver Paray on 3/31/20.
//  Copyright © 2020 Oliver Paray. All rights reserved.
//

import UIKit

class LaunchCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rocketLabel: UILabel!
    @IBOutlet weak var videoLink: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
