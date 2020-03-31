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
    lazy private(set) var searchByMissionResults = PublishSubject<LaunchesByMissionQuery.Data>()
    lazy private(set) var searchByRocketResults = PublishSubject<LaunchesByRocketQuery.Data>()
    lazy private(set) var searchByYearResults = PublishSubject<LaunchesByYearQuery.Data>()

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
                                guard let data = launchesByMissionResult.data else { return }
                                self.searchByMissionResults.on(.next(data))
                            case .failure(let error):
                                self.searchByMissionResults.onError(error)
                        }
                    }
                    case 1:
                        Network.shared.apollo.fetch(query: LaunchesByRocketQuery(name: searchCriteria.1)){ result in
                            switch result{
                                case .success(let launchesByRocketResult):
                                    guard let data = launchesByRocketResult.data else { return }
                                    self.searchByRocketResults.on(.next(data))
                                case .failure(let error):
                                    self.searchByMissionResults.onError(error)
                            }
                    }
                    default:
                        Network.shared.apollo.fetch(query: LaunchesByYearQuery(year: searchCriteria.1)) { result in
                            switch result {
                                case .success(let launchesByYearResult):
                                    guard let data = launchesByYearResult.data else { return }
                                    self.searchByYearResults.on(.next(data))
                                case .failure(let error):
                                    self.searchByYearResults.onError(error)
                            }
                        }
                    break
                }
            })
    }
}
