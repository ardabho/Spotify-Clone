//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 2.11.2023.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: Albums
}

struct Albums: Codable {
    let items: [Album]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}


