//
//  PlayerViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapForward()
    func didTapPlayPause()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 2 / 3),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        guard let url = dataSource?.shareURL else {
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL)
        controlsView.configure(model: PlayerControlsViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle))
    }
    
    public func refreshUI () {
        configure()
    }
    
}

extension PlayerViewController: PlayerControlsDelegate {
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    
    func PlayerControlsDidTapControlButton(_ playerControlsView: PlayerControlsView, buttonType: ButtonType) {
        switch buttonType {
        case .back:
            delegate?.didTapBackward()
        case .playPause:
            delegate?.didTapPlayPause()
        case .forward:
            delegate?.didTapForward()
        }
    }
}
