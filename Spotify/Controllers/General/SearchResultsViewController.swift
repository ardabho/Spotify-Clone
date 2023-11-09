//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapRow(_ rowInfo: SearchResult)
}

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

class SearchResultsViewController: UIViewController {

    private var sections: [SearchSection] = []
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SearchResultArtistTableViewCell.self, forCellReuseIdentifier: SearchResultArtistTableViewCell.identifier)
        tableView.register(SearchResultSubtitledTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitledTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        title = "Search Results"
        view.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        self.sections = [
        SearchSection(title: "Tracks", results: tracks),
        SearchSection(title: "Playlists", results: playlists),
        SearchSection(title: "Albums", results: albums),
        SearchSection(title: "Artists", results: artists)
        ]
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = self.sections.isEmpty
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = sections[indexPath.section].results[indexPath.row]
        
        switch cellData {
            
            //Playlist cells
        case .playlist(model: let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitledTableViewCell.identifier, for: indexPath) as? SearchResultSubtitledTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitledViewModel(mainLabelText: playlist.name, subtitleText: playlist.owner.displayName ?? "N/A", imageUrl: playlist.images.first?.url ?? ""))
            
            return cell

            
            //Album Cells
        case .album(model: let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitledTableViewCell.identifier, for: indexPath) as? SearchResultSubtitledTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: SearchResultSubtitledViewModel(mainLabelText: album.name, subtitleText: album.artists.first?.name ?? "N/A", imageUrl: album.images.first?.url ?? ""))
            
            return cell
            
            //Track cells
        case .track(model: let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitledTableViewCell.identifier, for: indexPath) as? SearchResultSubtitledTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: SearchResultSubtitledViewModel(mainLabelText: track.name, subtitleText: track.artists.first?.name ?? "N/A", imageUrl: track.album?.images.first?.url ?? ""))
            
            return cell
            
            
            //Artist cells
        case .artist(model: let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultArtistTableViewCell.identifier, for: indexPath) as? SearchResultArtistTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(viewModel: SearchResultArtistViewModel(name: artist.name, imageURL: artist.images?.first?.url ?? ""))
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        delegate?.didTapRow(result)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemGreen
    }
    
}
