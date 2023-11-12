//
//  SearchViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, SearchResultsViewControllerDelegate {
    
    private var categories: [Category] = []
    private var searchResults: [SearchResult] = []
    
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        vc.searchBar.tintColor = .label
        return vc
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(
                sectionProvider: { _, _ in
                    let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(0.5),
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(120)),
                        repeatingSubitem: item,
                        count: 2)
                    
                    group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
                    group.interItemSpacing = .fixed(10)
                    
                    return NSCollectionLayoutSection(group: group)
                }))
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getCategoriesData()
    }
    
    private func getCategoriesData() {
        APICaller.shared.getCategories { result in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async { [weak self] in
                    self?.categories = categories.categories.items
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.frame
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
                let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        resultsController.delegate = self
        
        //Clear all items before each call
        searchResults.removeAll()
        
        APICaller.shared.search(with: query) { status in
            DispatchQueue.main.async { [weak self] in
                switch status{
                case .success(let results):
                    
                    self?.searchResults.append(contentsOf: results.tracks.items.compactMap({
                        .track(model: $0)
                    }))
                    self?.searchResults.append(contentsOf: results.albums.items.compactMap({
                        .album(model: $0)
                    }))
                    self?.searchResults.append(contentsOf: results.artists.items.compactMap({
                        .artist(model: $0)
                    }))
                    self?.searchResults.append(contentsOf: results.playlists.items.compactMap({
                        .playlist(model: $0)
                    }))
                    
                    if let strongSelf = self {
                        resultsController.update(with: strongSelf.searchResults)
                    }
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func didTapRow(_ rowInfo: SearchResult) {
        switch rowInfo {
        case .album(model: let album):
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .artist(model: let model):
            break
        case .playlist(model: let playlist):
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(model: let track):
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(category: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

