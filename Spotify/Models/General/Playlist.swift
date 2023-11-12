//
//  Playlist.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 31.10.2023.
//

import Foundation

struct Playlist: Codable {
    let collaborative: Bool?
    let description: String
    let externalUrls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: Owner
    let primaryColor: String?
    let itemPublic: String?
    let snapshotID: String
    let tracks: Tracks?
    let type: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case collaborative, description, id, images, name, owner, tracks, type, uri
        case externalUrls = "external_urls"
        case primaryColor = "primary_color"
        case itemPublic = "public"
        case snapshotID = "snapshot_id"
    }
}
