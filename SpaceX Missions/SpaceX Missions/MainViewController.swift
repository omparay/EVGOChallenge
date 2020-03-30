//
//  ViewController.swift
//  SpaceX Missions
//
//  Created by Oliver Paray on 3/29/20.
//  Copyright © 2020 Oliver Paray. All rights reserved.
//

import Apollo
import RxSwift
import RxCocoa
import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Network.shared.apollo.fetch(query: LaunchesByYearQuery(year: "15")) { result in
            switch result {
                case .success(let data):
                debugPrint("Data: \(data)")
                guard let resultData = data.data, let launches = resultData.launchesPast else {
                    debugPrint("Error decoding json!!!")
                    return
                }
                for item in launches{
                    debugPrint("Date: \(String(describing: item?.launchDateUtc)) Name: \(String(describing: item?.missionName))")
                }
                case .failure(let error):
                debugPrint("Error: \(error)")
            }
            debugPrint("Finished execution!!!")
        }
    }


}

