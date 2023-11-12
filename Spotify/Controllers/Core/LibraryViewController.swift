//
//  LibraryViewController.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    private let categorySelector = LibraryTopSelector()
    
    let scrollView: UIScrollView = {
       let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.isPagingEnabled = true
        return scrollview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        view.backgroundColor = .systemBackground
        
        scrollView.delegate = self
        categorySelector.delegate = self
        
        view.addSubview(scrollView)
        view.addSubview(categorySelector)
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)
        addChildren()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        categorySelector.translatesAutoresizingMaskIntoConstraints = false
        
        //categorySelectorConstraints
        NSLayoutConstraint.activate([
            categorySelector.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categorySelector.bottomAnchor.constraint(equalTo: scrollView.topAnchor),
            categorySelector.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categorySelector.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
        
        
        //Scrollview Constraints:
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        
    }
    
    private func updateBarButtons() {
        if categorySelector.state == .playlist {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
            navigationController?.navigationBar.tintColor = .label
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAdd() {
        playlistsVC.showCreatePlaylistAlert()
    }
    
    private func addChildren() {
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = scrollView.frame
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
    }

}

extension LibraryViewController: UIScrollViewDelegate, LibraryTopSelectorDelegate {
    //MARK: Scrollview delegate methods
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= view.width / 2 {
            categorySelector.update(state: .album)
            updateBarButtons()
        } else {
            categorySelector.update(state: .playlist)
            updateBarButtons()
        }
    }
    
    //MARK: LibraryTopSelecetorMethods
    
    func libraryTopSelectorDidTapPlaylistButton(_ topSelectorView: LibraryTopSelector) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryTopSelectorDidTapAlbumsButton(_ topSelectorView: LibraryTopSelector) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
}
