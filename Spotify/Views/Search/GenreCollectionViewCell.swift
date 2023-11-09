//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 6.11.2023.
//

import UIKit
import SDWebImage

final class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        imageView.frame = contentView.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = contentView.center
        let labelConstraints = [
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    func configure(category: Category) {
        titleLabel.text = category.name
        imageView.sd_setImage(with: URL(string: category.icons.first?.url ?? ""), completed: nil)
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
