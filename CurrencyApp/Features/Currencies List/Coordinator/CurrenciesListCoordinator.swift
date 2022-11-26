//
//  CurrenciesListCoordinator.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation
import RxSwift
import FittedSheets

class CurrenciesListCoordinator: BaseCoordinator<Currency> {
    
    private let router: Routing
    private let currencies: [Currency]
    private let currencyType: CurrencyType
    
    init(router: Routing, currencies: [Currency], currencyType: CurrencyType) {
        self.router = router
        self.currencies = currencies
        self.currencyType = currencyType
    }
    
    @discardableResult
    override func start() -> Observable<Currency> {
        let viewController =  CurrenciesListVC()
        let viewModel = CurrenciesListViewModel(currencies: currencies)
        viewController.viewModel = viewModel
        
        //To display it like sheet
        let sheetViewController = SheetViewController(controller: viewController,
                                                      sizes: ([.percent(0.70)]),
                                                      options: FittedSheetCustomization.getSheetOptions())
        
        FittedSheetCustomization.setUPBottomSheet(sheetController: sheetViewController)
        router.present(sheetViewController, isAnimated: true, onDismiss: isCompleted)
        
        return subscribeToScreenResult(viewModel: viewModel)
    }
    
    func subscribeToScreenResult(viewModel: CurrenciesListViewModel)
    -> Observable<Currency> {
        return viewModel.output.selectedCurrencyObservable.do(onNext: { [weak self] _ in
            self?.router.dismissModule(animated: true)
        })
    }
}

enum PaymentMethod {
    case applyPay
    case debitCard
}
