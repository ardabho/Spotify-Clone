//
//  UserAlbumsResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 12.11.2023.
//

import Foundation

struct UserAlbumsResponse: Codable {
    let items: [SavedAlbum]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

