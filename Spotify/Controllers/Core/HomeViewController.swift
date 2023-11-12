//
//  ViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel]) // 0
    case featuredPlaylist(viewModels: [PlaylistCellViewModel]) // 1
    case recommendedTracks(viewModels: [TrackRowViewModel]) // 2
    
    var title: String {
        switch self {
        case .newReleases:
            return "New Released Albums"
        case .featuredPlaylist:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended Tracks"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var newAlbums = [Album]()
    private var featuredPlaylists = [Playlist]()
    private var recommendedTracks = [AudioTrack]()
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .done, target: self, action: #selector(didTapSettings))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        configureCollectionView()
        view.addSubview(spinner)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(NewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        
        collectionView.register(PlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        
        collectionView.register(TrackRowCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrackRowCollectionViewCell.identifier)
        collectionView.register(BrowseSectionTitle.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrowseSectionTitle.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylists?
        var recommendations: RecommendationsResponse?
        
        //New Releases
        APICaller.shared.getNewReleases { completionState in
            defer {
                group.leave()
            }
            switch completionState {
            case .success(let results):
                newReleases = results
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Featured Playlists
        APICaller.shared.getFeaturedPlaylists { completionState in
            defer {
                group.leave()
            }
            switch completionState {
            case .success(let results):
                featuredPlaylists = results
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //Recommended Tracks
        if let cachedGenres = UserDefaults.standard.array(forKey: "cachedGenres") as? [String] {
            print("Using cached genres")
            var genres = cachedGenres
            
            genres.shuffle()
            if genres.count > 5 {
                genres = Array(genres.prefix(5))
            }
            APICaller.shared.getRecommendations(genres: genres) {  completionState in
                defer {
                    group.leave()
                }
                switch completionState {
                case .success(let results):
                    recommendations = results
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        } else {
            
            APICaller.shared.getGenres { completionState in
                print("called the get genres api")
                switch completionState {
                case .success(let results):
                    let genresToCache = results.genres
                    UserDefaults.standard.set(genresToCache, forKey: "cachedGenres")
                    
                    var genres = results.genres
                    
                    if genres.count > 5 {
                        genres = Array(genres.prefix(5))
                    }
                    
                    APICaller.shared.getRecommendations(genres: genres) {  completionState in
                        defer {
                            group.leave()
                        }
                        switch completionState {
                        case .success(let results):
                            recommendations = results
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = recommendations?.tracks else {
                return
            }
            
            self.configureModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
        }
    }
    
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
        
        self.newAlbums = newAlbums
        self.featuredPlaylists = playlists
        self.recommendedTracks = tracks
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.totalTracks,
                artistName: $0.artists.first?.name ?? "N/A"
            )
        })))
        
        sections.append(.featuredPlaylist(viewModels: playlists.compactMap({
            return PlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.displayName ?? "N/A"
            )
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return TrackRowViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "N/A",
                artworkURL: URL(string: $0.album?.images.first?.url ?? "")
            )
        })))
        collectionView.reloadData()
    }
    
    @objc func didTapSettings () {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
}



//MARK: Collection View Delegate Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylist(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
            
            //New Releases Cell
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath
            ) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
            //FeaturedPlaylists Cell
        case .featuredPlaylist(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlaylistCollectionViewCell.identifier,
                for: indexPath
            ) as? PlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
            //Recommended Tracks Cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackRowCollectionViewCell.identifier,
                for: indexPath
            ) as? TrackRowCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        
            //New Releases Album Section
        case 0:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = album.name
            navigationController?.pushViewController(vc, animated: true)
            
            //Featured Playlists Section
        case 1:
            let playlist = featuredPlaylists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = playlist.name
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            let track = recommendedTracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: BrowseSectionTitle.identifier,
            for: indexPath) as? BrowseSectionTitle,
            kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        let title = sections[section].title
        sectionHeader.configure(title: title)
        return sectionHeader
    }
    
    //Create Section Layout
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let sectionHeader = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        ]
        
        switch section {
            //New Released Albums
        case 0:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0 / 3)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Vertical Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                repeatingSubitem: item,
                count: 3)
            
            //Horizontal Group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(390)),
                repeatingSubitem: verticalGroup,
                count: 1)
            
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = sectionHeader
            return section
            
            //Featured Playlists
        case 1:
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Vertical Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                repeatingSubitem: item,
                count: 2
            )
            
            //Horizontal Group
            let screenWidth = UIScreen.main.bounds.size.width
            var width = screenWidth * 0.45
            if width > 200 { width = 200 }
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(width),
                    heightDimension: .absolute(width * 2.8)
                ),
                repeatingSubitem: verticalGroup,
                count: 1
            )
            
            //Section:
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = sectionHeader
            return section
            
            //Recommended Tracks
        case 2:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                repeatingSubitem: item,
                count: 1)
            
            //Section
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = sectionHeader
            return section
            
        default:
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                repeatingSubitem: item,
                count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

