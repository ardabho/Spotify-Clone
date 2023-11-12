//
//  LibraryViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 10.11.2023.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    private var playlists = [UserPlaylists]()
    
    private let actionLabel: ActionLabelView = {
        let actionView = ActionLabelView()
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.isHidden = true
        actionView.configure(with: ActionLabelViewModel(text: "You don't have any playlists, yet", actionTitle: "Create One"))
        return actionView
    }()
    
    private let playlistTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(SearchResultSubtitledTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitledTableViewCell.identifier)
        tableview.backgroundColor = .systemBackground
        tableview.isHidden = true
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(actionLabel)
        view.addSubview(playlistTableView)
        
        actionLabel.delegate = self
        playlistTableView.dataSource = self
        playlistTableView.delegate = self
        
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
        
        playlistTableView.frame = view.frame
    }
    
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self.playlists = playlists.items
                    self.updateUI()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            actionLabel.isHidden = false
            playlistTableView.isHidden = true
        } else {
            playlistTableView.reloadData()
            actionLabel.isHidden = true
            playlistTableView.isHidden = false
        }
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New Playlist",
                                      message: "Enter playlist name. ",
                                      preferredStyle: .alert
        )
        
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            //Create a playlist by calling spotify api
        }))
        
        present(alert, animated: true)
    }
    
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitledTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitledTableViewCell else {
            return UITableViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(with: SearchResultSubtitledViewModel(
            mainLabelText: playlist.name,
            subtitleText: playlist.description ?? "",
            imageUrl: playlist.images.first?.url ?? ""
            
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let playlist = playlists[indexPath.row]
        let convertedPlaylist = Playlist(
            collaborative: playlist.collaborative,
            description: playlist.description ?? "",
            externalUrls: playlist.external_urls,
            id: playlist.id,
            images: playlist.images,
            name: playlist.name,
            owner: playlist.owner,
            primaryColor: nil,
            itemPublic: nil,
            snapshotID: playlist.snapshot_id,
            tracks: playlist.tracks,
            type: nil,
            uri: nil
        )
        let vc = PlaylistViewController(playlist: convertedPlaylist)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
    
}
