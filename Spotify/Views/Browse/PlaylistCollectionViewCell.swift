//
//  PlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 3.11.2023.
//

import UIKit
import SDWebImage

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    //Components
    let playlistArtworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "music.note")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let playlistCreatorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .thin)
        label.textAlignment = .center
        return label
    }()
    
    
    let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.spacing = 2
        
        return stackview
    }()
    
    //init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 5
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(playlistArtworkImageView)
        stackView.addArrangedSubview(playlistNameLabel)
        stackView.addArrangedSubview(playlistCreatorNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = contentView.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        playlistNameLabel.sizeToFit()
        playlistCreatorNameLabel.sizeToFit()
        
        let constraints = [
            playlistArtworkImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            playlistArtworkImageView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
            playlistNameLabel.heightAnchor.constraint(equalTo: playlistCreatorNameLabel.heightAnchor, multiplier: 2)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func configure(with model: PlaylistCellViewModel) {
        playlistArtworkImageView.sd_setImage(with: model.artworkURL)
        playlistNameLabel.text = model.name
        playlistCreatorNameLabel.text = model.creatorName
    }
    
    override func prepareForReuse() {
        playlistArtworkImageView.image = nil
        playlistNameLabel.text = nil
        playlistCreatorNameLabel.text = nil
    }
}

