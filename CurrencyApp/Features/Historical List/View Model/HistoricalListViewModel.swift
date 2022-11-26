//
//  HistoricalListViewModel.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

class HistoricalListViewModel: BaseViewModel {

    struct Input {
        let selectedCurrency: AnyObserver<Currency>
    }
    
    struct Output {
        let currenciesObservable: Observable<[Currency]>
        let selectedCurrencyObservable: Observable<Currency>
    }
    
    let output: Output
    let input: Input
    
    private let currenciesSubject: BehaviorRelay<[Currency]> = BehaviorRelay(value: [])
    private let selectedCurrencySubject = PublishSubject<Currency>()


    override init() {
        self.input = Input(selectedCurrency: selectedCurrencySubject.asObserver())
        self.output = Output(currenciesObservable: currenciesSubject.asObservable(),
                             selectedCurrencyObservable: selectedCurrencySubject.asObservable())
        super.init()
        
        
    }
}
