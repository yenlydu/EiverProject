//
//  TrailersCarousselViewModel.swift
//  eiver
//
//  Created by Duong Yen-Ly on 30/07/2021.
//

import Foundation

class TrailersCarousselViewModel : ObservableObject {
    @Published var trailers: [FilmYoutubeVideo] = []
    @Published var index = 0

    init() {
    }
}
