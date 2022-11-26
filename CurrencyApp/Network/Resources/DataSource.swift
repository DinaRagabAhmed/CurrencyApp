//
//  DataSource.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation

class DataSource {
    static func provideNetworkDataSource() -> NetworkManager {
        return NetworkManager.shared
    }
}
