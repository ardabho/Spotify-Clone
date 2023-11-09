//
//  Playlists.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 7.11.2023.
//

import Foundation

struct Playlists: Codable {
    let items: [Playlist]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: Int?
    let total: Int
}
