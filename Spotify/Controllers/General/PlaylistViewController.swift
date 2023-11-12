//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist
    private var playlistViewModels = [TrackRowViewModel]()
    private var tracks = [AudioTrack]()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        // Group
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            repeatingSubitem: item,
            count: 1)
        
        //Section
        let section = NSCollectionLayoutSection(group: group)
        
        //Header
        section.boundarySupplementaryItems = [ NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: NSRectAlignment.top
        )
        ]
        return section
    }))
    
    //Loading Indicator
    private let loadingIndicatorView = LoadingIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .label

        title = playlist.name
        view.backgroundColor = .systemBackground
        configureCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapActionButton))
        view.addSubview(loadingIndicatorView)
        loadingIndicatorView.frame = view.bounds
        
    }
    
    @objc private func didTapActionButton() {
        guard let url = URL(string: playlist.externalUrls["spotify"] ?? "") else {
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
        init(playlist: Playlist) {
//        print("playlist id is: ", playlist.id)
//        print("playlist name is: ", playlist.name)
//        print("playlist id is: ", playlist.description)
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
        fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchData() {
        loadingIndicatorView.startLoading()
        
        APICaller.shared.getPlaylist(id: playlist.id) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async { [weak self] in
                    self?.playlistViewModels = result.tracks.items.compactMap({
                        let viewModel = TrackRowViewModel(
                            name: $0.track.name,
                            artistName: $0.track.artists.first?.name ?? "-",
                            artworkURL: URL(string: $0.track.album?.images.first?.url ?? "")
                        )
                        self?.tracks.append($0.track)
                        return viewModel
                    })
                    self?.collectionView.reloadData()
                    self?.loadingIndicatorView.stopLoading()
                }
                
            case .failure(let error):
                print(error)
                self.loadingIndicatorView.stopLoading()
            }
        }
    }
    
}

//MARK: COLLECTION VIEW

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(
            TrackRowCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackRowCollectionViewCell.identifier
        )
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlistViewModels.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackRowCollectionViewCell.identifier, for: indexPath) as? TrackRowCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = playlistViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? PlaylistHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerViewModel = PlaylistHeaderViewModel(
            name: playlist.name,
            description: playlist.description,
            owner: playlist.owner.displayName,
            imageUrl: URL(string: playlist.images.first?.url ?? "")
        )

        header.configure(with: headerViewModel)
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //Play song
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
        
    }
    
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //Start play list play in queue
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
