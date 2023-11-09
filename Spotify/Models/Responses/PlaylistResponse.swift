//
//  PlaylistResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 5.11.2023.
//

import Foundation

struct PlaylistResponse: Codable {
    let collaborative: Bool
    let description: String?
    let external_urls: [String: String]
    let followers: Followers
    let id: String
    let images: [APIImage]
    let name: String
    let owner: Owner
    let snapshot_id: String
    let tracks: PlaylistTracks
    
}

struct PlaylistTracks: Codable {
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [PlaylistTrack]
}

struct PlaylistTrack: Codable {
    let added_at: String?
    let track: AudioTrack
}


