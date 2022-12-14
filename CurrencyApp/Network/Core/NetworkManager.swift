//
//  NetworkManager.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import RxSwift
import Moya

class NetworkManager: DataManager {
    
    static let shared = NetworkManager()
    let provider: MoyaProvider<MultiTarget>
    
    var disposeBag = DisposeBag()
    
    private init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)

        provider = MoyaProvider<MultiTarget>(
            plugins: [NetworkLoggerPlugin(configuration: loggerConfig)])
    }
}
