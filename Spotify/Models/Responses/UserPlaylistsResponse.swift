//
//  UserPlaylistsResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 12.11.2023.
//

import Foundation

struct UserPlaylistsResponse: Decodable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let preivous: String?
    let items: [UserPlaylists]
}

struct UserPlaylists: Decodable {
        let collaborative: Bool?
        let description: String?
        let external_urls: [String: String]
        let followers: Followers?
        let id: String
        let images: [APIImage]
        let name: String
        let owner: Owner
        let snapshot_id: String
        let tracks: Tracks
}
