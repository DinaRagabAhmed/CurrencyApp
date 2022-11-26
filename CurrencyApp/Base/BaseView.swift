//
//  BaseView.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation

// MARK: - Base View
protocol BaseView: AnyObject {
    
    func showLoading()
    func hideLoading()
    func showNetworkError()
    func showGeneralError()
}
