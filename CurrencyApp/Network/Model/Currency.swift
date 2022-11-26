//
//  Currency.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation

class Currency {
    var symbol: String
    var currencyFullName: String
    
    init(symbol: String, currencyFullName: String) {
        self.symbol = symbol
        self.currencyFullName = currencyFullName
    }
}
