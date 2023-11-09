//
//  LoadingIndicatorView.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 7.11.2023.
//

import UIKit

final class LoadingIndicatorView: UIView {

    private let overlay: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(overlay)
        overlay.isHidden = true
        
        addSubview(activityIndicator)
        
        isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        overlay.frame = frame
        
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: topAnchor),
            overlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        overlay.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        overlay.isHidden = true
        activityIndicator.stopAnimating()
    }
}
