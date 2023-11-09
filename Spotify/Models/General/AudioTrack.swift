//
//  AudioTrack.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import Foundation

struct AudioTrack: Codable {
    let album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_ids: [String: String]?
    let external_urls: [String: String]?
    let id: String
    let is_local: Bool?
    let name: String
    let popularity: Int?
    let preview_url: String?
    let track_number: Int
    let type: String
    let uri: String
}
