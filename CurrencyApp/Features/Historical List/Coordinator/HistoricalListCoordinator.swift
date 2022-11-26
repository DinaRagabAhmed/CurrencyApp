//
//  HistoricalListCoordinator.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 26/11/2022.
//

import Foundation
import RxSwift
import UIKit

class HistoricalListCoordinator: BaseCoordinator<Void> {
    
    private let router: Routing

    init(router: Routing) {
        self.router = router
    }
    
    @discardableResult
    override func start() -> Observable<Void> {
        let viewController =  HistoricalListVC()
        let viewModel = HistoricalListViewModel()
        viewController.viewModel = viewModel
        
        router.push(viewController, isAnimated: true, onNavigateBack: isCompleted)
        
       // bindToScreenNavigation(viewModel: viewModel)
        return Observable.never()
    }
    
    // Binding
//    func bindToScreenNavigation(viewModel: NotificationsListViewModel) {
//        viewModel.output.screenRedirectionObservable
//            .subscribe(onNext: { [weak self](redirection) in
//                guard let self = self else { return }
//                switch redirection {
//                case .back:
//                    self.router.pop(true)
//                }
//            })
//            .disposed(by: bag)
//    }
}

enum HistoricalListRedirection {
    case back
}
