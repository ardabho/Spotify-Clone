//
//  PlayerViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        
        configureBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 2 / 3)
        ]
        
        let playerControlsViewConstraints = [
            controlsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlsView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            controlsView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1, constant: -20),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(playerControlsViewConstraints)
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), style: .done, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapAction() {
        //Actions
    }
    
}

extension PlayerViewController: PlayerControlsDelegate {
    
    func PlayerControlsDidTapControlButton(_ playerControlsView: PlayerControlsView, buttonType: ButtonType) {
        switch buttonType {
        case .back:
            print("pressed back button")
        case .playPause:
            print("pressed play pause button")
        case .forward:
            print("pressed forward button")
        }
    }
    
    
}
