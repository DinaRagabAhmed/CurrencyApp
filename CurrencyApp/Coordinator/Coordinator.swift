//
//  Coordinator.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation

// MARK: - Coordinator
// To add coordinators in array and remove it from memory after deallocations
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    
    func add(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
}
