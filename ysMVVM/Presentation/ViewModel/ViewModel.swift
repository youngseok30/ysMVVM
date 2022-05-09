//
//  ViewModel.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/09.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel: BaseVM {
    
    let disposeBag = DisposeBag()
    let movieService = DI.container.resolve(MovieListRepository.self)
    
    let items = PublishRelay<MoviesPage?>()
    
    init() {}
    
    private func fetchData() {
        movieService?.fetchMovieList(query: "car", page: 1)?
            .subscribe(onNext: { result in
                switch result {
                case .success(let result):
                    print(result)
                    self.items.accept(result)
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
    }
}

extension ViewModel {
    
    func viewDidLoad() {
        fetchData()
    }
    
    func viewWillAppear() {}
    
}
