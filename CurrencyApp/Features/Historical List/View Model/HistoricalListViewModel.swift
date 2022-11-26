//
//  HistoricalListViewModel.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


class HistoricalListViewModel: BaseViewModel {

    struct Input {
    }
    
    struct Output {
        let dataObservable: Observable<[SectionModel<String, HistoricalExchangeData>]>
    }
    
    let output: Output
    let input: Input
    
    private let dataSubject: BehaviorRelay<[SectionModel<String, HistoricalExchangeData>]> = BehaviorRelay(value: [])
    var dateManager = DateManager()


    override init() {
        self.input = Input()
        self.output = Output(dataObservable: dataSubject.asObservable())
        
        super.init()
        setupData()
    }
    
    func setupData() {
        let historicalData = UserDefault().getHistoricalData()
        var historicalDataDictionary = [String: [HistoricalExchangeData]]()
        for item in historicalData {
            if let searchHistoryofDate = historicalDataDictionary[item.date] {
                var data = searchHistoryofDate
                data.append(item)
                historicalDataDictionary[item.date] = data
            } else {
                historicalDataDictionary[item.date] = [item]
            }
        }
        
        let sectionModels = historicalDataDictionary.map { (key, value) in
            return SectionModel(model: key, items: value)
        }
                
        dataSubject.accept(sectionModels.sorted { (dateManager.convertDateToStringWithFormat(dateString: $0.model) ?? Date()) < (dateManager.convertDateToStringWithFormat(dateString: $1.model) ?? Date()) })
    }
    
}
