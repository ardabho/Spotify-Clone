//
//  TrackRowCollectionViewCell.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 3.11.2023.
//

import UIKit
/*
 let name: String
     let artistName: String
     let artworkURL: URL?
 */

class TrackRowCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    //Components
    let descriptionStackView: UIStackView = {
       let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fillProportionally
        stackview.spacing = 5
        return stackview
    }()
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "music.note")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 5
        clipsToBounds = true
        
        addSubview(coverImageView)
        addSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(trackNameLabel)
        descriptionStackView.addArrangedSubview(artistNameLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = contentView.bounds.height - 10
        
        let imageViewConstraints = [
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            coverImageView.widthAnchor.constraint(equalToConstant: height),
            coverImageView.heightAnchor.constraint(equalToConstant: height),
        ]
        
        let remainingContentWidth = contentView.bounds.width - 20 - height
        let stackViewConstraints = [
            descriptionStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            descriptionStackView.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            descriptionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            descriptionStackView.widthAnchor.constraint(equalToConstant: remainingContentWidth),
            descriptionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with model: TrackRowViewModel) {
        coverImageView.sd_setImage(with: model.artworkURL)
        trackNameLabel.text = model.name
        artistNameLabel.text = model.artistName
    }
    
}
