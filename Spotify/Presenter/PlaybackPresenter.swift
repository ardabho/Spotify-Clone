//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 9.11.2023.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
    var shareURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var albumImageURL: String?
    
    var currentTrack: AudioTrack? {
        if let track, tracks.isEmpty {
            return track
        }
        else if let player = self.queuePlayer, !tracks.isEmpty {
            return tracks[index]
        }
        
        return nil
    }
    
    var player: AVPlayer?
    var queuePlayer: AVQueuePlayer?
    var playerVC: PlayerViewController?
    
    var index = 0
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack,
        albumImageURL: String? = nil
    ) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        queuePlayer?.pause()
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        if let albumImageURL { self.albumImageURL = albumImageURL }
        let vc = PlayerViewController()
        
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack],
        albumImageURL: String? = nil
    ) {
        player?.pause()
        self.track = nil
        self.tracks = tracks
        
        self.queuePlayer = AVQueuePlayer(items: tracks.compactMap({
            guard let urlString = $0.preview_url,
                    let url = URL(string: urlString ) else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.queuePlayer?.volume = 0.5
        self.queuePlayer?.play()
        
        if let albumImageURL { self.albumImageURL = albumImageURL }
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
        self.playerVC = vc
    }
    
}

extension PlaybackPresenter: PlayerDataSource, PlayerViewControllerDelegate {
    
    func didSlideSlider(_ value: Float) {
        if let player {
            player.volume = value
        }
    }
    
    func didTapPlayPause() {
        if let player {
            if player.timeControlStatus == .playing  {
                player.pause()
            } else if player.timeControlStatus == .paused{
                player.play()
            }
        } else if let player = queuePlayer {
            if player.timeControlStatus == .playing  {
                player.pause()
            } else if player.timeControlStatus == .paused{
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
         //Not playlist or album
            player?.pause()
        } else if let player = queuePlayer{
            player.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty{
            //Not playlist or album
            player?.pause()
            player?.play()
        }
    }
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        if let url = currentTrack?.album?.images.first?.url {
            return URL(string: url)
        } else {
            return URL(string: albumImageURL ?? "")
        }
    }
    
    var shareURL: URL? {
        if let urlString = currentTrack?.external_urls?["spotify"],
        let url = URL(string: urlString)
        {
            return url
        } else {
            return nil
        }
    }
     
}

