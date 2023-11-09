//
//  CategoryPlaylistsResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 7.11.2023.
//

import Foundation

struct CategoryPlaylistsResponse: Decodable {
    let message: String?
    let playlists: Playlists
}
