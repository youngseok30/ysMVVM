//
//  Network.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/08.
//

import Foundation
import RxSwift
import Moya

enum NetworkServiceError: Error {
    case parseFailed(Error)
    case moyaError(MoyaError)
    case serverError(Response)
}

protocol NetworkServiceInterface {
    
    func request<T: Codable>(endpoint: Endpoint, type: T.Type) -> Observable<Result<T, Error>>
}

class NetworkService {
    
    lazy private var provider: MoyaProvider<Endpoint> = {
        return MoyaProvider<Endpoint>(plugins: [])
    }()
  
    private func request<T: Codable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable? {
        
        return provider.request(endpoint, completion: { (result) in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedData = try JSONDecoder().decode(T.self, from: filteredResponse.data)
                    completion(.success(decodedData))
                }
                catch MoyaError.statusCode(let code) {
                    completion(Result.failure(NetworkServiceError.serverError(code)))
                }
                catch (let error) {
                    completion(Result.failure(NetworkServiceError.parseFailed(error)))
                }
                
            case .failure(let error):
                completion(Result.failure(NetworkServiceError.moyaError(error)))
            }
        })
    }
    
}

extension NetworkService: NetworkServiceInterface {
    
    func request<T: Codable>(endpoint: Endpoint, type: T.Type) -> Observable<Result<T, Error>> {
        return Observable.create { (observer) -> Disposable in
            let task = self.request(endpoint: endpoint, type: type, completion: { result in
                observer.onNext(result)
                observer.onCompleted()
            })
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
}

