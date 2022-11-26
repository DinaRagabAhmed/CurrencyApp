//
//  DataManager.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Foundation
import Moya
import RxSwift

protocol DataManager {
    func callApi<T: Codable>(target: TargetType, type: T.Type) -> Observable<Result<T?, NetworkError>>
    func cancelAllRequests()
}
