//
//  MovieListRepository.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/09.
//

import Foundation
import RxSwift

protocol MovieListRepository {
    @discardableResult
    func fetchMovieList(query: String?, page: Int) -> Observable<Result<MoviesPage, Error>>?
    func fetchMovieList2(query: String?, page: Int) -> Single<MoviesPage>?
    
}

class MovieListApiService: MovieListRepository {
    let networkService = DI.container.resolve(NetworkServiceInterface.self)
    
    func fetchMovieList(query: String?, page: Int) -> Observable<Result<MoviesPage, Error>>? {
        return networkService?.request(endpoint: .fetchMovieList(query ?? "", page), type: MoviesPage.self)
    }
    
    func fetchMovieList2(query: String?, page: Int) -> Single<MoviesPage>? {
        return networkService?.request(endpoint: .fetchMovieList(query ?? "", page), type: MoviesPage.self)
    }
    
}
