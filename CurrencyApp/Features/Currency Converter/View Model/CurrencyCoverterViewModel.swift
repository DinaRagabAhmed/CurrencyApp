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
        let amount: AnyObserver<String>
        let didSwapCurrencies: AnyObserver<Void>
        let didTapDetails: AnyObserver<Void>
    }
    
    struct Output {
        let fromCurrencyObservable: Observable<Currency?>
        let toCurrencyObservable: Observable<Currency?>
        let conversionResultObservable: Observable<Double?>
        let currenciesObservable: Observable<[Currency]>
        let screenRedirectionObservable: Observable<CurrencyConverterRedirection>
        let screenStatusObservable: Observable<ScreenStatus>
    }
    
    let output: Output
    let input: Input
    
    private let currenciesSubject: BehaviorRelay<[Currency]> = BehaviorRelay(value: [])
    private let fromCurrencySubject: BehaviorRelay<Currency?> = BehaviorRelay(value: nil)
    private let toCurrencySubject: BehaviorRelay<Currency?> = BehaviorRelay(value: nil)
    private let conversionResultSubject: BehaviorRelay<Double?> = BehaviorRelay(value: nil)
    private let amountSubject = PublishSubject<String>()
    private let screenRedirectionSubject = PublishSubject<CurrencyConverterRedirection>()
    private let selectedCurrencyTypeSubject = PublishSubject<CurrencyType>()
    private let rateSubject: BehaviorRelay<Double?> = BehaviorRelay(value: nil)
    private let screenStatusSubject = PublishSubject<ScreenStatus>()
    private let swapCurrenciesSubject = PublishSubject<Void>()
    private let detailsSubject = PublishSubject<Void>()

    var dataManager: DataManager?
    
    init(dataManager: DataManager?) {
        self.dataManager = dataManager
        self.input = Input(didSelectCurrencyType: selectedCurrencyTypeSubject.asObserver(),
                           amount: amountSubject.asObserver(),
                           didSwapCurrencies: swapCurrenciesSubject.asObserver(),
                           didTapDetails: detailsSubject.asObserver())
        self.output = Output(fromCurrencyObservable: fromCurrencySubject.asObservable(),
                             toCurrencyObservable: toCurrencySubject.asObservable(),
                             conversionResultObservable: conversionResultSubject.asObservable(), currenciesObservable: currenciesSubject.asObservable(),
                             screenRedirectionObservable: screenRedirectionSubject.asObservable(),
                             screenStatusObservable: screenStatusSubject.asObservable())
        super.init()
        
        subscribeToCurrencyTypeSelection()
        subscribeToAmountChanges()
        subscribeToSwapCurrencies()
        subscribeToHistoricalDetails()
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
    
    
    func subscribeToAmountChanges() {
        Observable.combineLatest(amountSubject.asObservable(), rateSubject.asObservable()).subscribe { [weak self] (amount, rate) in
            self?.calculateResult(amount: Double(amount) ?? 1, rate: rate ?? 0)
        }.disposed(by: disposeBag)
    }
    
    func subscribeToSwapCurrencies() {
        swapCurrenciesSubject.asObservable()
           .subscribe { [weak self] _ in
               self?.swapCurrencies()
           }.disposed(by: disposeBag)
    }
    
    func subscribeToHistoricalDetails() {
        detailsSubject.asObservable()
           .subscribe { [weak self] _ in
               self?.screenRedirectionSubject.onNext(.historicalDetails)
           }.disposed(by: disposeBag)
    }
}

// MARK: - Calculations and business logic
extension CurrencyCoverterViewModel {
    
    func calculateResult(amount: Double, rate: Double) {
        let result = amount * rate
        conversionResultSubject.accept(result.round(to: 2))
    }
    
    func swapCurrencies() {
        let fromCurrency = self.fromCurrencySubject.value
        let toCurrency = self.toCurrencySubject.value
        
        self.fromCurrencySubject.accept(toCurrency)
        self.toCurrencySubject.accept(fromCurrency)
        
        let fromCurrencySymbol = self.fromCurrencySubject.value?.symbol ?? ""
        let toCurrencySymbol = self.toCurrencySubject.value?.symbol ?? ""
       
        self.controlLoading(showLoading: true)
        self.getRate(from: fromCurrencySymbol, to: toCurrencySymbol, amount: 1)
    }
}

// MARK: - Handle Network call and response
extension CurrencyCoverterViewModel {
    
    func getSymbols() {
        
        if Utils.isConnectedToNetwork() {
            self.controlLoading(showLoading: true)
            let target = CurrencyServices.getSymbols
            self.dataManager?.callApi(target: target, type: SymbolsResponse.self).subscribe(onNext: { [weak self] result in
                print(result)
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                switch result {
                case .success (let data):
                    if let data = data {
                        self.screenStatusSubject.onNext(.dataLoaded)
                        let currencies = (data.symbols ?? [:]).map({ (key , value) in
                            return Currency(symbol: key, currencyFullName: value)
                        })
                        self.currenciesSubject.accept(currencies.sorted { $0.symbol.lowercased() < $1.symbol.lowercased()})
                        self.setDefaultCurrencies()
                    }
                    
                case .failure(let error):
                    if !Utils.isConnectedToNetwork() {
                        self.screenStatusSubject.onNext(.noNetwork)
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
            self.screenStatusSubject.onNext(.noNetwork)

        }
    }
    
    func getRate(from: String, to: String, amount: Int) {
        
        // Called to get the base amount
        if Utils.isConnectedToNetwork() {
            let target = CurrencyServices.convertCurrency(from: from, to: to, amount: amount)
            self.dataManager?.callApi(target: target, type: ConversionResponse.self).subscribe(onNext: { [weak self] result in
                print(result)
                guard let self = self else { return }
                self.controlLoading(showLoading: false)
                switch result {
                case .success (let data):
                    self.screenStatusSubject.onNext(.dataLoaded)
                    self.rateSubject.accept(data?.result ?? 0)
                    self.saveHistoricalData(date: data?.date ?? "")
                case .failure(let error):
                    if !Utils.isConnectedToNetwork() {
                        self.screenStatusSubject.onNext(.noNetwork)
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
            self.screenStatusSubject.onNext(.noNetwork)
        }
    }
    
    
    func setDefaultCurrencies() {
        let currencyCode  = Locale.current.currencyCode ?? "EGP"
        let defaultFromCurrency = self.currenciesSubject.value.first(where: { $0.symbol.lowercased() == currencyCode.lowercased()})
        
        let toCurrencyCode = currencyCode == "USD" ? "EGP" : "USD"
        let defaultToCurrency = self.currenciesSubject.value.first(where: { $0.symbol.lowercased() == toCurrencyCode.lowercased()})
        
        self.fromCurrencySubject.accept(defaultFromCurrency)
        self.toCurrencySubject.accept(defaultToCurrency)
        
        self.setupRateRequest()
        
    }
    
    func selectCurrency(currency: Currency, currencyType: CurrencyType) {
        switch currencyType {
        case .from:
            self.fromCurrencySubject.accept(currency)
        case .to:
            self.toCurrencySubject.accept(currency)
        }
        
        setupRateRequest()
       
    }
    
    func setupRateRequest() {
        if fromCurrencySubject.value != nil && toCurrencySubject.value != nil {
            let fromCurrencySymbol = self.fromCurrencySubject.value?.symbol ?? ""
            let toCurrencySymbol = self.toCurrencySubject.value?.symbol ?? ""
           
            self.controlLoading(showLoading: true)
            self.getRate(from: fromCurrencySymbol, to: toCurrencySymbol, amount: 1)
        }
    }
    
    func saveHistoricalData(date: String) {
        let historicalData = HistoricalExchangeData(date: date,
                                                    fromCurrency: self.fromCurrencySubject.value?.symbol ?? "",
                                                    toCurrency: self.toCurrencySubject.value?.symbol ?? "",
                                                    rate: self.rateSubject.value ?? 0)
        UserDefault().setHistoricalData(data: historicalData)
    }
    
    func retryNetworkConnection() {
        if self.currenciesSubject.value.isEmpty {
            self.getSymbols()
        } else if fromCurrencySubject.value != nil && toCurrencySubject.value != nil {
            let fromCurrencySymbol = self.fromCurrencySubject.value?.symbol ?? ""
            let toCurrencySymbol = self.toCurrencySubject.value?.symbol ?? ""
           
            self.getRate(from: fromCurrencySymbol, to: toCurrencySymbol, amount: 1)

        }
    }
}
