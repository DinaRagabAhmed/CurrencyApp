//
//  ViewModelProtocol.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation

// MARK: - View Model Protocol
/// Input type should contain observers (e.g. AnyObserver) that should be subscribed to UI elements that emit input events.
/// Output type should contain observables that emit events related to result of processing of inputs.
protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
}
