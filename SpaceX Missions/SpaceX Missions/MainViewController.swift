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

        Network.shared.apollo.fetch(query: LaunchesQuery()) { result in
            switch result {
                case .success(let data):
                debugPrint("Data: \(data)")
                guard let results = data.data,
                    let jsonData = try? JSONSerialization.data(withJSONObject: results.jsonObject, options: .prettyPrinted),
                    let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any],
                    let launches = jsonDict["launchesPast"] as? [[String:String]]
                else { return }
                for item in launches {
                    debugPrint("Launch: \(String(describing: item["mission_name"])) Date: \(String(describing: item["launch_date_utc"]))")
                }
                case .failure(let error):
                debugPrint("Error: \(error)")
            }
            debugPrint("Finished execution!!!")
        }
    }


}

