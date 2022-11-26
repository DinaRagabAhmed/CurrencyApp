//
//  CurrencyConverterCoordinator.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//
import RxSwift
import UIKit

class CurrencyConverterCoordinator: BaseCoordinator<Void> {
    
    private let router: Routing

    init(router: Routing) {
        self.router = router
    }
    
    @discardableResult
    override func start() -> Observable<Void> {
        let viewController =  CurrencyConverterVC()
        let viewModel = CurrencyCoverterViewModel(dataManager: DataSource.provideNetworkDataSource())
        viewController.viewModel = viewModel
        
        router.pushToRoot(viewController, isAnimated: true, onNavigateBack: isCompleted)
        
        bindToScreenNavigation(viewModel: viewModel)
        return Observable.never()
    }
    
    //Binding
    func bindToScreenNavigation(viewModel: CurrencyCoverterViewModel) {
        viewModel.output.screenRedirectionObservable
            .subscribe(onNext: { [weak self](redirection) in
                guard let self = self else { return }
                switch redirection {
                case .currenciesList(let currencies, let currencyType):
                    self.redirectToCurrencyList(viewModel: viewModel, currencies: currencies, currencyType: currencyType)
                case .historicalDetails:
                    self.redirectToHistoricalDetails()
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Navigation
extension CurrencyConverterCoordinator {

    func redirectToCurrencyList(viewModel: CurrencyCoverterViewModel, currencies: [Currency], currencyType: CurrencyType) {
        self.childCoordinators.removeAll()
        
        let currenciesListCoordinator = CurrenciesListCoordinator(router: router, currencies: currencies, currencyType: currencyType)
        self.add(coordinator: currenciesListCoordinator)
       
        currenciesListCoordinator.start().subscribe(onNext: { [weak self, weak viewModel] currency in
            guard let viewModel = viewModel else { return }
            viewModel.selectCurrency(currency: currency, currencyType: currencyType)
            self?.childCoordinators.removeAll()
        }).disposed(by: currenciesListCoordinator.bag)
    }
    
    func redirectToHistoricalDetails() {
        let historicalListCoordinator = HistoricalListCoordinator(router: router)
        self.add(coordinator: historicalListCoordinator)
         
        historicalListCoordinator.isCompleted = { [weak self, weak historicalListCoordinator] in
             guard let coordinator = historicalListCoordinator else {
                 return
             }
             self?.remove(coordinator: coordinator)
         }
         
        historicalListCoordinator.start()
    }
}


enum CurrencyConverterRedirection {
    case currenciesList(currencies: [Currency], currencyType: CurrencyType)
    case historicalDetails
}

enum CurrencyType {
    case from
    case to
}
