//
//  AlbumResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 5.11.2023.
//

import Foundation

struct AlbumResponse: Decodable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let copyrights: [CopyRight]
    let external_ids: [String: String]
    let external_urls: [String: String]
    let genres: [String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let popularity: Int
    let release_date: String
    let release_date_precision: String
    let total_tracks: Int
    let tracks: SpotifyTrack
    let type: String
    let uri: String;
}

struct CopyRight: Decodable {
    let text: String
    let type: String
}

struct SpotifyTrack: Decodable {
    let items: [AudioTrack]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

