//
//  SettingsModels.swift
//  Spotify
//
//  Created by ARDA BUYUKHATIPOGLU on 1.11.2023.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
