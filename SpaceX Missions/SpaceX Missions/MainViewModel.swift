//
//  MainViewModel.swift
//  SpaceX Missions
//
//  Created by Oliver Paray on 3/29/20.
//  Copyright © 2020 Oliver Paray. All rights reserved.
//

import Apollo
import Foundation
import RxSwift
import RxCocoa

class MainViewModel {

    //Properties
    lazy private(set) var searchResults = BehaviorRelay<[LaunchData]>(value: [])

    init(
        criteriaSelection: Driver<Int>,
        searchText: Driver<String>
    ){
        let _ = Driver.combineLatest(criteriaSelection,searchText).drive(
            onNext: { searchCriteria in
                switch searchCriteria.0 {
                    case 0:
                    Network.shared.apollo.fetch(query: LaunchesByMissionQuery(mission: searchCriteria.1)){ result in
                        switch result{
                            case .success(let launchesByMissionResult):
                                guard let resultData = launchesByMissionResult.data, let results = resultData.launchesPast else { return }
                                var converted = [LaunchData]()
                                for item in results {
                                    if let mission = item?.missionName, let rocket = item?.rocket?.rocketName, let dateutc = item?.launchDateUtc, let vidlink = item?.links?.videoLink {
                                        let launchData = LaunchData(missionName: mission, rocketName: rocket, launchUTC: dateutc, videoLink: vidlink)
                                        converted.append(launchData)
                                    } else { continue }
                                }
                                self.searchResults.accept(converted)
                            case .failure:
                                break
                        }
                    }
                    case 1:
                        Network.shared.apollo.fetch(query: LaunchesByRocketQuery(name: searchCriteria.1)){ result in
                            switch result{
                                case .success(let launchesByRocketResult):
                                    guard let resultData = launchesByRocketResult.data, let results = resultData.launchesPast else { return }
                                    var converted = [LaunchData]()
                                    for item in results {
                                        if let mission = item?.missionName, let rocket = item?.rocket?.rocketName, let dateutc = item?.launchDateUtc, let vidlink = item?.links?.videoLink {
                                            let launchData = LaunchData(missionName: mission, rocketName: rocket, launchUTC: dateutc, videoLink: vidlink)
                                            converted.append(launchData)
                                        } else { continue }
                                    }
                                    self.searchResults.accept(converted)
                                case .failure:
                                    break
                            }
                    }
                    default:
                        Network.shared.apollo.fetch(query: LaunchesByYearQuery(year: searchCriteria.1)) { result in
                            switch result {
                                case .success(let launchesByYearResult):
                                    guard let resultData = launchesByYearResult.data, let results = resultData.launchesPast else { return }
                                    var converted = [LaunchData]()
                                    for item in results {
                                        if let mission = item?.missionName, let rocket = item?.rocket?.rocketName, let dateutc = item?.launchDateUtc, let vidlink = item?.links?.videoLink {
                                            let launchData = LaunchData(missionName: mission, rocketName: rocket, launchUTC: dateutc, videoLink: vidlink)
                                            converted.append(launchData)
                                        } else { continue }
                                    }
                                    self.searchResults.accept(converted)
                                case .failure:
                                    break
                            }
                        }
                    break
                }
            })
    }
}
