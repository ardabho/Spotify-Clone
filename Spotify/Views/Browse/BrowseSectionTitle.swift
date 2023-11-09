//
//  BrowseSectionTitle.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 6.11.2023.
//

import UIKit

final class BrowseSectionTitle: UICollectionReusableView {
    
    static let identifier = "BrowseSectionTitle"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
}
