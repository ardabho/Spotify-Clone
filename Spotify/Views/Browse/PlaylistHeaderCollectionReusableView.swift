//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 6.11.2023.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    //Namelabel
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    //descriptionlabel
    private let descriptionLabel: UILabel = {
           let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
        }()
    
    //ownerlabel
    private let ownerLabel: UILabel = {
           let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .thin)
        return label
        }()
    
    //playlistimage
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.image = UIImage(systemName: "photo")
        return imageview
    }()
    
    //playbutton
    private let playAllbutton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()
    
    //MARK: - İnit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playAllbutton)
        playAllbutton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlayAll() {
        delegate?.PlaylistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = bounds.height / 1.8
        
        let labelHeight: CGFloat = (bounds.height - imageSize - 40) / 3
        
        
        imageView.frame = CGRect(x: (width-imageSize) / 2, y: 20, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width - 20, height: labelHeight)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width - 20, height: labelHeight)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width - 20, height: labelHeight + 20)
        
        let playButtonConstraints = [
            playAllbutton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            playAllbutton.widthAnchor.constraint(equalToConstant: labelHeight + 10),
            playAllbutton.heightAnchor.constraint(equalToConstant: labelHeight + 10 ),
            playAllbutton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ]
        
        playAllbutton.layer.cornerRadius = (labelHeight + 10) / 2
        
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.owner
        imageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
