//
//  CurrencyCoverterViewModel.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyCoverterViewModel: BaseViewModel {

    struct Input {
        let didSelectCurrencyType: AnyObserver<CurrencyType>
    }
    
    struct Output {
        let fromCurrencyObservable: Observable<Currency?>
        let toCurrencyObservable: Observable<Currency?>
        let currenciesObservable: Observable<[Currency]>
        let screenRedirectionObservable: Observable<CurrencyConverterRedirection>
    }
    
    let output: Output
    let input: Input
    
    private let currenciesSubject: BehaviorRelay<[Currency]> = BehaviorRelay(value: [])
    private let fromCurrencySubject: BehaviorRelay<Currency?> = BehaviorRelay(value: nil)
    private let toCurrencySubject: BehaviorRelay<Currency?> = BehaviorRelay(value: nil)

    private let screenRedirectionSubject = PublishSubject<CurrencyConverterRedirection>()
    private let selectedCurrencyTypeSubject = PublishSubject<CurrencyType>()
    
    var dataManager: DataManager?
    var rate: Double? = nil
    
    init(dataManager: DataManager?) {
        self.dataManager = dataManager
        self.input = Input(didSelectCurrencyType: selectedCurrencyTypeSubject.asObserver())
        self.output = Output(fromCurrencyObservable: fromCurrencySubject.asObservable(),
                             toCurrencyObservable: toCurrencySubject.asObservable(),
                             currenciesObservable: currenciesSubject.asObservable(),
                             screenRedirectionObservable: screenRedirectionSubject.asObservable())
        super.init()
        
        subscribeToCurrencyTypeSelection()
    }
}

// MARK: - Handle View Model Inputs
extension CurrencyCoverterViewModel {
    
    func subscribeToCurrencyTypeSelection() {
        selectedCurrencyTypeSubject.asObservable()
            .filter { [weak self] _ in
                return !(self?.currenciesSubject.value.isEmpty ?? false)
            }.subscribe(onNext: {[weak self] type in
                self?.screenRedirectionSubject.onNext(.currenciesList(currencies: self?.currenciesSubject.value ?? [], currencyType: type))
            }).disposed(by: disposeBag)
    }
 
}
// MARK: - Handle Network call and response
extension CurrencyCoverterViewModel {
    
    func getSymbols() {
        
        if Utils.isConnectedToNetwork() {
            let target = CurrencyServices.getSymbols
            self.dataManager?.callApi(target: target, type: SymbolsResponse.self).subscribe(onNext: { [weak self] result in
                print(result)
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                switch result {
                case .success (let data):
                    if let data = data {
                        let currencies = (data.symbols ?? [:]).map({ (key , value) in
                            return Currency(symbol: key, currencyFullName: value)
                        })
                        self.currenciesSubject.accept(currencies.sorted { $0.symbol.lowercased() < $1.symbol.lowercased()})
                    }
                    
                case .failure(let error):
                    if !Utils.isConnectedToNetwork() {
                       // self.screenStateSubject.onNext(.noNetwork)
                    } else {
                        self.setError(error: error.type ?? ErrorTypes.generalError)
                    }
                }
            }, onError: { [weak self](error) in
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                self.setError(error: ErrorTypes.generalError)
            }).disposed(by: disposeBag)
        } else {
            self.controlLoading(showLoading: false)
          //  self.screenStateSubject.onNext(.noNetwork)

        }
    }
    
    func getRate(from: String, to: String, amount: Int) {
        
        if Utils.isConnectedToNetwork() {
            let target = CurrencyServices.convertCurrency(from: from, to: to, amount: amount)
            self.dataManager?.callApi(target: target, type: ConversionResponse.self).subscribe(onNext: { [weak self] result in
                print(result)
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                switch result {
                case .success (let data):
                    self.rate = data?.result ?? 0
                case .failure(let error):
                    if !Utils.isConnectedToNetwork() {
                       // self.screenStateSubject.onNext(.noNetwork)
                    } else {
                        self.setError(error: error.type ?? ErrorTypes.generalError)
                    }
                }
            }, onError: { [weak self](error) in
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                self.setError(error: ErrorTypes.generalError)
            }).disposed(by: disposeBag)
        } else {
            self.controlLoading(showLoading: false)
          //  self.screenStateSubject.onNext(.noNetwork)

        }
    }
    
    func selectCurrency(currency: Currency, currencyType: CurrencyType) {
        switch currencyType {
        case .from:
            self.fromCurrencySubject.accept(currency)
        case .to:
            self.toCurrencySubject.accept(currency)
        }
        
        if fromCurrencySubject.value != nil && toCurrencySubject.value != nil {
            let fromCurrencySymbol = self.fromCurrencySubject.value?.symbol ?? ""
            let toCurrencySymbol = self.toCurrencySubject.value?.symbol ?? ""
           
            self.getRate(from: fromCurrencySymbol, to: toCurrencySymbol, amount: 1)

        }
    }
}
