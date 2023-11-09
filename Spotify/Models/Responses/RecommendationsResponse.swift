//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 2.11.2023.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
