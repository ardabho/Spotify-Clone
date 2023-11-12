//
//  LibraryViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 10.11.2023.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
    private var albums = [SavedAlbum]()
    
    private let actionLabel: ActionLabelView = {
        let actionView = ActionLabelView()
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.isHidden = true
        actionView.configure(with: ActionLabelViewModel(
            text: "You have not any saved albums, yet",
            actionTitle: "Browse")
        )
        return actionView
    }()
    
    private let albumsTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(SearchResultSubtitledTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitledTableViewCell.identifier)
        tableview.backgroundColor = .systemBackground
        tableview.isHidden = true
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(actionLabel)
        view.addSubview(albumsTableView)
        
        actionLabel.delegate = self
        albumsTableView.dataSource = self
        albumsTableView.delegate = self
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let actionLabelConstraints = [
            actionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionLabel.widthAnchor.constraint(equalToConstant: view.width / 2),
            actionLabel.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(actionLabelConstraints)
        
        let albumTableViewConstraints = [
            albumsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            albumsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            albumsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ]
        
        NSLayoutConstraint.activate(albumTableViewConstraints)
    }
    
    private func fetchData() {
        APICaller.shared.getUserAlbums { result in
            DispatchQueue.main.async { [weak self] in
                
                switch result {
                case .success(let albums):
                    self?.albums = albums.items
                    self?.updateUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func updateUI() {
        if albums.isEmpty {
            actionLabel.isHidden = false
            albumsTableView.isHidden = true
        } else {
            albumsTableView.reloadData()
            actionLabel.isHidden = true
            albumsTableView.isHidden = false
        }
    }
    
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitledTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitledTableViewCell else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row].album
        
        cell.configure(with: SearchResultSubtitledViewModel(
            mainLabelText: album.name,
            subtitleText: album.artists.first?.name ?? "N/A",
            imageUrl: album.images.first?.url ?? ""
            
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let album = albums[indexPath.row].album
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
