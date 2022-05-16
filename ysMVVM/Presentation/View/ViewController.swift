//
//  ViewController.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/08.
//

import UIKit

class ViewController: UIViewController, BaseMVVMView, Storyboarded {
    static var storyboardName: String = Constants.Storyboard.main
    static var storyboardID: String = ViewController.className
    
    private let searchEmptyView: SearchEmptyView = {
        return SearchEmptyView()
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: .grid)
        view.delegate = self
        view.isPrefetchingEnabled = true
        view.prefetchDataSource = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.registerId)

        return view
    }()
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addSubviews()
        setupCollectionView()
        setupSearchController()
        makeConstraints()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {
            self.navigationItem.searchController?.searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    func bind(to viewModel: ViewModel) {
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "movie poster search"
    }

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(searchEmptyView)
    }

    private func setupCollectionView() {
        viewModel.dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.registerId, for: indexPath)
            (cell as? CollectionViewCell)?.model = photo
            self?.viewModel.loadImages(for: photo)

            return cell
        })
    }

    private func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        searchEmptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchEmptyView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            searchEmptyView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            searchEmptyView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            searchEmptyView.topAnchor.constraint(equalTo: collectionView.topAnchor)
        ])
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search movie posters"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

extension ViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {        
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainFromBottom = contentHeight - yOffset

        let frameHeight = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight * 2.0 {
            viewModel.fetchData()
        }
    }
    
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { viewModel.prefetchImage(at: $0) }
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchEmptyView.isHidden = searchBar.text?.isEmpty == false
        viewModel.clearDataSource()
        viewModel.fetchData(with: searchBar.text ?? "")
    }
    
}
