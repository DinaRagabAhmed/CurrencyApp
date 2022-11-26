//
//  CurrencyResponse.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation

class SymbolsResponse: Codable {
    var success: Bool
    var symbols: [String: String]?
}
