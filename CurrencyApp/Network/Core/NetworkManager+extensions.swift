//
//  NetworkManager+extensions.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import Moya
import RxSwift

extension NetworkManager {
    
    func callApi<T: Codable>(target: TargetType, type: T.Type) -> Observable<Result<T?, NetworkError>> {
        
        return Observable.create { [weak self] observer in
          
            self?.provider.rx.request(MultiTarget(target)).asObservable().subscribe { (response) in
                
                do {
                    let basicReponse = try JSONDecoder().decode(T.self, from: response.data)
                    
                    
                    if response.statusCode == StatusCode.success.rawValue ||  response.statusCode == StatusCode.successCode.rawValue {
                        observer.onNext(.success(basicReponse))
                    } else {
                        observer.onNext(.failure(NetworkError(type: ErrorTypes.generalError)))
                    }
                } catch {
                 
                         observer.onNext(.failure(NetworkError(type: ErrorTypes.generalError)))
        
                }
                
            } onError: { error in
                // Handle error
                 observer.onNext(.failure(NetworkError(type: ErrorTypes.unKnown)))
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }.disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }

    }
    
    func cancelAllRequests() {
        self.provider.session.cancelAllRequests()
    }

}
