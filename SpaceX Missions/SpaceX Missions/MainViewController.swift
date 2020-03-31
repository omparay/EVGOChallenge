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
    }

    func bind(){
        viewModel.searchResults.bind(to: resultsTableView.rx.items(cellIdentifier: "LaunchCell")){
            row, model, cell in
            debugPrint("\(model.missionName):\(model.launchUTC)")
            guard let launchCell = cell as? LaunchCell else {
                debugPrint("Stupid return!!!")
                return
            }
            launchCell.missionLabel.text = "Mission: \(model.missionName)"
            launchCell.dateLabel.text = "Date: \(model.launchUTC)"
            launchCell.rocketLabel.text = "Rocket: \(model.rocketName)"
            launchCell.videoLink.setTitle("\(model.videoLink)", for: .normal)
        }.disposed(by: disposeBag)
    }
}

