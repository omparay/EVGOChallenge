//
//  ViewController.swift
//  SpaceX Missions
//
//  Created by Oliver Paray on 3/29/20.
//  Copyright © 2020 Oliver Paray. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import RxCocoa
import UIKit

class MainViewController: UIViewController {

    //Outlets
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var criteriaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!

    //Properties
    let disposeBag = DisposeBag()
    lazy var viewModel = MainViewModel(
        criteriaSelection: criteriaSegmentedControl.rx.selectedSegmentIndex.asDriver(),
        searchText: searchTextField.rx.text.orEmpty.asDriver())

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()

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

    func bind(){
        viewModel.searchByMissionResults.subscribe(
            onNext: { (results) in
                guard let launches = results.launchesPast else { return }
                for item in launches{
                    debugPrint("Date: \(String(describing: item?.launchDateUtc)) Name: \(String(describing: item?.missionName))")
                }
        },
            onError: { (error) in
        }).disposed(by: disposeBag)

        viewModel.searchByRocketResults.subscribe(
            onNext: { (results) in
                guard let launches = results.launchesPast else { return }
                for item in launches{
                    debugPrint("Date: \(String(describing: item?.launchDateUtc)) Name: \(String(describing: item?.missionName))")
                }
        },
            onError: { (error) in
        }).disposed(by: disposeBag)

        viewModel.searchByYearResults.subscribe(
            onNext: { (results) in
                guard let launches = results.launchesPast else { return }
                for item in launches{
                    debugPrint("Date: \(String(describing: item?.launchDateUtc)) Name: \(String(describing: item?.missionName))")
                }
        },
            onError: { (error) in
        }).disposed(by: disposeBag)
    }
}

