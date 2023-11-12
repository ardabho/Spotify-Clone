//
//  SearchResultSubtitledTableViewCell.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 9.11.2023.
//

import UIKit
import SDWebImage

class SearchResultSubtitledTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultSubtitledTableViewCell"
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let cellImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(subtitleLabel)
        
        contentView.clipsToBounds = true
        
        accessoryType = .disclosureIndicator
    }
    
    private func setConstraints() {
        //imageview constraints
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            cellImageView.heightAnchor.constraint(equalToConstant: contentView.height - 10),
            cellImageView.widthAnchor.constraint(equalToConstant: contentView.height - 10),
        ])
        
        //Main Label constraints
        NSLayoutConstraint.activate([
            mainLabel.heightAnchor.constraint(equalTo: subtitleLabel.heightAnchor, multiplier: 1),
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        //SubtitleLabelConstraints
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(greaterThanOrEqualTo: mainLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainLabel.text = nil
        subtitleLabel.text = nil
        cellImageView.image = nil
    }
    
    public func configure(with viewModel: SearchResultSubtitledViewModel) {
        mainLabel.text = viewModel.mainLabelText
        subtitleLabel.text = viewModel.subtitleText
        cellImageView.sd_setImage(with: URL(string:viewModel.imageUrl))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
