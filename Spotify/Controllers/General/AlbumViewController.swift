//
//  AlbumViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 5.11.2023.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album: Album
    private var albumViewModels = [TrackRowViewModel]()
    private var tracks = [AudioTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        
        title = album.name
        view.backgroundColor = .systemBackground
        configureCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapActionButton)
        )
    }
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
        getAlbumData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getAlbumData() {
        APICaller.shared.getAlbum(id: album.id) { result in
            switch result {
            case .success(let album):
                DispatchQueue.main.async { [weak self] in
                    
                    self?.albumViewModels = album.tracks.items.compactMap({
                                       //Change
                                       let viewModel = TrackRowViewModel(
                                        name: $0.name,
                                        artistName: $0.artists.first?.name ?? "-",
                                        artworkURL: URL(string: album.images.first?.url ?? "")
                                       )
                        self?.tracks = album.tracks.items
                        return viewModel
                                   })
                                   
                                   self?.collectionView.reloadData()
                               }
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
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
    
    @objc private func didTapActionButton() {
        guard let url = URL(string: album.externalUrls["spotify"] ?? "") else {
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
    
}

//MARK: COLLECTION VIEW

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        albumViewModels.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackRowCollectionViewCell.identifier, for: indexPath) as? TrackRowCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = albumViewModels[indexPath.row]
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
            name: album.name,
            description: "Release Date: \(String.formattedDate(string: album.releaseDate ?? "undefined"))" ,
            owner: album.artists.first?.name,
            imageUrl: URL(string: album.images.first?.url ?? "")
        )

        header.configure(with: headerViewModel)
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        PlaybackPresenter.shared.startPlayback(from: self, track: tracks[indexPath.row], albumImageURL: self.album.images.first?.url)
    }
    
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //Start play list play in queue
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
