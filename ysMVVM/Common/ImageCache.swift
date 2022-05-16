//
//  ImageCache.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/16.
//

import Foundation
import UIKit
import RxSwift

protocol Item {
    var image: UIImage { get set }
    var imageUrl: URL { get }
    var identifier: UUID { get }
}

typealias ImageCompletion = (Item, UIImage?) -> Void

class ImageCache {
    
    let networkService: NetworkServiceInterface
    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }

    private let cache = NSCache<NSURL, UIImage>()
    private var prefetches: [UUID] = []
    private var completions: [NSURL: [ImageCompletion]]? = [:]
    lazy var disposeBag : DisposeBag = {
        return DisposeBag()
    }()
    

    func prefetchImage(for item: Item) {
        let url = item.imageUrl as NSURL
        guard cachedImage(for: url) == nil, !prefetches.contains(item.identifier) else { return }
        prefetches.append(item.identifier)

        networkService.downloadImage(url: item.imageUrl.absoluteString)
            .subscribe({ [weak self] result in
                switch result {
                case .success(let image):
                    self?.cache.setObject(image, forKey: url)
                    self?.prefetches.removeAll { $0 == item.identifier }
                default: break
                }
            }).disposed(by: disposeBag)
    }

    func loadImage(for item: Item, completion: @escaping ImageCompletion) {
        let url = item.imageUrl as NSURL
        if let image = cachedImage(for: url) {
            completion(item, image)
            return
        }

        if completions?[url] != nil {
            completions?[url]?.append(completion)
            return
        } else {
            completions?[url] = [completion]
        }
        
        networkService.downloadImage(url: item.imageUrl.absoluteString)
            .subscribe({ [weak self] result in
                switch result {
                case .success(let image):
                    guard let completions = self?.completions?[url] else {
                        completion(item, nil)
                        return
                    }

                    self?.cache.setObject(image, forKey: url)

                    completions.forEach { completion in
                        completion(item, image)
                    }
                case .failure(let error):
                    print(error)
                    completion(item, nil)
                }

                self?.completions?.removeValue(forKey: url)
            }).disposed(by: disposeBag)
    }

    func reset() {
        completions?.removeAll()
        prefetches.removeAll()
        cache.removeAllObjects()
    }

    private func cachedImage(for url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }
    
}
