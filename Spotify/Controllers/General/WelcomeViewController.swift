//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "albums_background"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(signInButton)
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
        
        signInButton.frame = CGRect(
            x: 20,
            y: (view.bottom - view.safeAreaInsets.bottom) - 70,
            width: view.width - 40,
            height: 50
        )
        
        logoImageView.frame = CGRect(x: (view.width - 120) / 2, y: (view.height - 250) / 2, width: 120, height: 120)
        welcomeLabel.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: view.width - 60, height: 150)
    }
    
    @objc private func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        //Log User in or yell at them for error
        guard success else {
            let alert = UIAlertController(title: "Sorry!", message: "Could not login.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        
        present(mainAppTabBarVC, animated: true)
        
    }
}
