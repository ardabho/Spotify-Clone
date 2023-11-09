//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 3.11.2023.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView  = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "music.note")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 2
        return label
    }()
    
    let numberOfTrack: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 5
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTrack)
        contentView.clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = contentView.bounds.height - 10
        
//        albumNameLabel.sizeToFit()
//        artistNameLabel.sizeToFit()
//        numberOfTrack.sizeToFit()
        
        //Album Image Constraints
        let albumImageConstraints = [
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  5),
            albumCoverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: height),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: height)
        ]
        
        //Album Name Constraints
        let albumNameLabelConstraints = [
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 10),
            albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        ]
        //Artist Name Constraints
        let artistNameLabelConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 10),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ]
        //Number Of Track Constraints
        let numberOfTrackLabelConstraints = [
            numberOfTrack.topAnchor.constraint(greaterThanOrEqualTo: artistNameLabel.bottomAnchor, constant: 5),
            numberOfTrack.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 10),
            numberOfTrack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            numberOfTrack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ]
        
        //Activate Constraints
        NSLayoutConstraint.activate(albumImageConstraints)
        NSLayoutConstraint.activate(albumNameLabelConstraints)
        NSLayoutConstraint.activate(artistNameLabelConstraints)
        NSLayoutConstraint.activate(numberOfTrackLabelConstraints)
        
    }
    
    override func prepareForReuse() {
        albumCoverImageView.image = nil
        artistNameLabel.text = nil
        albumNameLabel.text = nil
        numberOfTrack.text = nil
    }
    
    func configure(with model: NewReleasesCellViewModel) {
        albumCoverImageView.sd_setImage(with: model.artworkURL)
        albumNameLabel.text = model.name
        artistNameLabel.text = model.artistName
        numberOfTrack.text = "Tracks: \(model.numberOfTracks)"
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}
