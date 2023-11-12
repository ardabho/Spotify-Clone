//
//  LibraryTopSelector.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 10.11.2023.
//

import UIKit

protocol LibraryTopSelectorDelegate: AnyObject {
    func libraryTopSelectorDidTapPlaylistButton(_ topSelectorView: LibraryTopSelector)
    func libraryTopSelectorDidTapAlbumsButton(_ topSelectorView: LibraryTopSelector )
}

class LibraryTopSelector: UIView {

    
    weak var delegate: LibraryTopSelectorDelegate?
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    private let playlistsButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.layer.borderWidth = 2.0
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        
        return button
    }()
    
    
    
    private let albumsButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .secondarySystemBackground
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistsButton)
        addSubview(albumsButton)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylistButton), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbumsButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
        
        UIView.animate(withDuration: 0.2) {
            if self.state == .playlist {
                self.albumsButton.backgroundColor = .secondarySystemBackground
                self.playlistsButton.backgroundColor = .systemGreen
            } else if self.state == .album {
                self.albumsButton.backgroundColor = .systemGreen
                self.playlistsButton.backgroundColor = .secondarySystemBackground
            }
        }
    }
    
    private func setConstraints() {
        
        let buttonHeight = frame.height - 5
        let buttonWidth = frame.width / 5.5
        
        let playlistButtonConstraints = [
            playlistsButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            playlistsButton.widthAnchor.constraint(equalToConstant: buttonWidth * 2),
            playlistsButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: buttonWidth / 2),
            playlistsButton.trailingAnchor.constraint(equalTo: albumsButton.leadingAnchor, constant: -(buttonWidth / 2))
        ]
        
        let albumsButtonConstraints = [
            albumsButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            albumsButton.widthAnchor.constraint(equalToConstant: buttonWidth * 2),
            albumsButton.leadingAnchor.constraint(equalTo: playlistsButton.trailingAnchor, constant: buttonWidth / 2),
            albumsButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -(buttonWidth / 2))
        ]
        
        NSLayoutConstraint.activate(playlistButtonConstraints)
        NSLayoutConstraint.activate(albumsButtonConstraints)
        playlistsButton.layer.cornerRadius = buttonHeight / 2
        albumsButton.layer.cornerRadius = buttonHeight / 2

    }
    
    @objc private func didTapPlaylistButton() {
        delegate?.libraryTopSelectorDidTapPlaylistButton(self)
    }
    
    @objc private func didTapAlbumsButton() {
        delegate?.libraryTopSelectorDidTapAlbumsButton(self)
    }
    
    public func update(state: State) {
        let beforeState = self.state
        if beforeState != state {
            self.state = state
            setNeedsLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
