//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 2.11.2023.
//

import Foundation

struct FeaturedPlaylists: Codable {
    let message: String?
    let playlists: Playlists
}


