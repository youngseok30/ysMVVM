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
    func request<T: Codable>(endpoint: Endpoint, type: T.Type) -> Single<T>
    func downloadImage(url: String) -> Single<Image>
}

class NetworkService {
    
    lazy private var provider: MoyaProvider<Endpoint> = {
        return MoyaProvider<Endpoint>(plugins: [])
    }()
  
    private func request<T: Codable>(endpoint: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable? {
        
        return provider.request(endpoint, completion: { [weak self] (result) in
            self?.checkResponse(result: result, completion: { filterdResult in
                switch filterdResult {
                case .success(let data):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(NetworkServiceError.parseFailed(error)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        })
    }
    
    private func request(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        return provider.request(endpoint, completion: { [weak self] (result) in
            self?.checkResponse(result: result, completion: { filterdResult in
                switch filterdResult {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        })
    }
    
    private func checkResponse(result: Result<Response, MoyaError>, completion: @escaping (Result<Data, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                let filteredResponse = try response.filterSuccessfulStatusCodes()
                completion(.success(filteredResponse.data))
            } catch MoyaError.statusCode(let code) {
                completion(.failure(NetworkServiceError.serverError(code)))
            } catch (let error) {
                completion(.failure(NetworkServiceError.parseFailed(error)))
            }
            
        case .failure(let error):
            completion(.failure(NetworkServiceError.moyaError(error)))
        }
    }
    
}

extension NetworkService: NetworkServiceInterface {
    func downloadImage(url: String) -> Single<Image> {
        provider.rx.request(Endpoint.download(url: url))
            .mapImage()
    }
    
    
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
    
    func request<T: Codable>(endpoint: Endpoint, type: T.Type) -> Single<T> {
        provider.rx.request(endpoint)
            .filter(statusCodes: 200..<299)
            .map(type, failsOnEmptyData: false)        
    }
    
}

