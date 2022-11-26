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
        let sectionModels = historicalData.map { (key, value) in
            return SectionModel(model: key, items: value)
        }

        dataSubject.accept(sectionModels.sorted { (dateManager.getDate(dateString: $0.model) ?? Date()) < (dateManager.getDate(dateString: $1.model) ?? Date()) })
    }
    
}
