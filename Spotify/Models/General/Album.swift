//
//  Album.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 2.11.2023.
//

import Foundation

struct Album: Codable {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]?
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let releaseDate: String?
    let releaseDatePrecision: String?
    let totalTracks: Int
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case id
        case images
        case name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type
        case uri
    }
}
