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

        guard let url = URL(string: "https://api.spacex.land/") else {
            print("Failed to generate URL...")
            return
        }
        print("Executing query...")
        let apollo = ApolloClient(url: url)
        apollo.fetch(query: LaunchesQuery(), cachePolicy: .fetchIgnoringCacheCompletely) { (result) in
            switch result{
                case .success(let data):
                    print("Success: \(data)")
                case .failure(let error):
                    print("Error: \(error)")
            }
        }
    }


}

