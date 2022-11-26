//
//  AppCoordinator.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private var router: Routing?
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = false
        navigationController.navigationBar.backgroundColor = .systemTeal
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return navigationController
    }()

    init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    override func start() -> Observable<Void> {
        self.childCoordinators.removeAll()
        return navigateToCurrencyConverterVC()
    }
 

    func startIntialScreen(coordinator: BaseCoordinator<Void>) -> Observable<Void> {
        self.add(coordinator: coordinator)
        
        coordinator.isCompleted = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else {
                return
            }
            self?.remove(coordinator: coordinator)
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinator.start()
    }
    
    func navigateToCurrencyConverterVC() -> Observable<Void> {
        let router = Router(navigationController: navigationController)
        let currencyConverterCoordinator = CurrencyConverterCoordinator(router: router)

        self.router = router
        return startIntialScreen(coordinator: currencyConverterCoordinator)
    }
}
