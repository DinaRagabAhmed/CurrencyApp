//
//  CurrencyServices.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation
import Moya

enum CurrencyServices {
    case getSymbols
    case convertCurrency(from: String, to: String, amount: Int)
}

extension CurrencyServices: TargetType {
    
    // This is the base URL we'll be using, typically our server.
    var baseURL: URL {
        let baseURL = Environment.baseURL
        guard let url = URL(string: baseURL) else { fatalError("wrong baseURL in Route") }
        return url
    }
    
    // This is the path of each operation that will be appended to our base URL.
    var path: String {
        switch self {
        case .getSymbols:
            return "symbols"
        case .convertCurrency:
            return "convert"
        }
    }
    
    // Here we specify which method our calls should use.
    var method: Moya.Method {
        switch self {
        case .getSymbols, .convertCurrency:
            return .get
        }
    }
    
    // Here we specify body parameters, objects, files etc.
    // or just do a plain request without a body.
    var task: Task {
        switch self {
        case .getSymbols:
            return .requestPlain
        case .convertCurrency(let from, let to, let amount):
            let parameters = ["from": from, "to": to, "amount": amount] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    // These are the headers that our service requires.
    var headers: [String: String]? {
        return ["accept": "application/json", "apikey": Environment.APIKey]
    }
    
    // This is sample return data that you can use to mock and test your services,
    var sampleData: Data {
        return Data()
    }
}
