//
//  SearchResultArtistTableViewCell.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 8.11.2023.
//

import UIKit
import SDWebImage

class SearchResultArtistTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultArtistTableViewCell"
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let artistImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(artistImageView)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentHeight = contentView.height - 10
        
        artistImageView.frame = CGRect(x: 10, y: 5, width: contentHeight, height: contentHeight)
                
        artistImageView.layer.cornerRadius = contentHeight / 2
        
        let labelWidth = contentView.width - artistImageView.right - 30
        
        artistNameLabel.frame = CGRect(x: artistImageView.right + 15, y: 5, width: labelWidth, height: contentHeight)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = nil
        artistImageView.image = nil
    }
    
    public func configure(viewModel: SearchResultArtistViewModel) {
        print("")
        artistNameLabel.text = viewModel.name
        artistImageView.sd_setImage(with: URL(string: viewModel.imageURL ?? ""))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
