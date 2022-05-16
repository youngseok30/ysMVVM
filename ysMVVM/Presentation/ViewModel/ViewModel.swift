//
//  ViewModel.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/09.
//

import Foundation
import RxSwift
import RxCocoa

enum Section: Int, CaseIterable {
    case main
}

class ViewModel: BaseVM {
    
    let disposeBag = DisposeBag()
    let movieService = DI.container.resolve(MovieListRepository.self)
    
    let imageCache = ImageCache(networkService: DI.container.resolve(NetworkServiceInterface.self)!)
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var query = ""
    var currentPage: Int = 0
    
    init() {}
    
    func fetchData(with query: String = "") {
        guard let searchQuery = getSearchQuery(compared: query) else { return }
        self.query = searchQuery

        currentPage += 1
        
        movieService?.fetchMovieList2(query: self.query, page: currentPage)?
            .subscribe({ [weak self] result in
                guard let weakSelf = self else { return }
                
                switch result {
                case .success(let result):
                    print(result)
                    var snapshot = weakSelf.dataSource.snapshot()
                    if snapshot.sectionIdentifiers.isEmpty {
                        snapshot.appendSections([.main])
                    }
                    snapshot.appendItems(result.toDomain())
                    DispatchQueue.global(qos: .background).async {
                        weakSelf.dataSource.apply(snapshot, animatingDifferences: false)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: disposeBag)
    }
    
    func prefetchImage(at indexPath: IndexPath) {
        guard let photo = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        imageCache.prefetchImage(for: photo)
    }

    func loadImages(for photo: Photo) {
        imageCache.loadImage(for: photo) { [weak self] item, image in
            guard let weakSelf = self else { return }
            guard let photo = item as? Photo else { return }
            guard let image = image, image != photo.image else { return }

            photo.image = image
            var snapshot = weakSelf.dataSource.snapshot()
            guard snapshot.indexOfItem(photo) != nil else { return }

            snapshot.reloadItems([photo])
            DispatchQueue.global(qos: .background).async {
                weakSelf.dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    
    private func getSearchQuery(compared query: String) -> String? {
        let searchQuery = query.isEmpty ? self.query : query
        return searchQuery.isEmpty ? nil : searchQuery
    }
    
    func clearDataSource() {
        currentPage = 0
        var snapShot = dataSource.snapshot()
        snapShot.deleteAllItems()
        DispatchQueue.global(qos: .background).async {
            self.dataSource.apply(snapShot, animatingDifferences: false)
        }
    }
    
}

extension ViewModel {
    
    func viewDidLoad() {}
    func viewWillAppear() {}
    
}
