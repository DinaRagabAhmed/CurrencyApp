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


    override init() {
        self.input = Input()
        self.output = Output(dataObservable: dataSubject.asObservable())
        
        super.init()
        setupData()
    }
    
    func setupData() {
        var historicalData = UserDefault().getHistoricalData()
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
        
        var sectionModels = historicalDataDictionary.map { (key, value) in
            return SectionModel(model: key, items: value)
        }
        
        dataSubject.accept(sectionModels)
    }
    
}
