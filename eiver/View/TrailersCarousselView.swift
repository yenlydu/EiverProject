//
//  FilmsDetailView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import SwiftUI
struct TrailersCaroussel: View {
    @StateObject var trailerViewModel: TrailersCarousselViewModel

    init(trailers: [FilmYoutubeVideo], trailerViewModel: TrailersCarousselViewModel = .init()) {
        _trailerViewModel = StateObject(wrappedValue: trailerViewModel)
        trailerViewModel.trailers = trailers
        UITabBar.appearance().backgroundColor = UIColor.red
    }

    var body: some View {

    }
}

struct TrailersCaroussel_Previews: PreviewProvider {
    static var previews: some View {
        TrailersCaroussel(trailers: [])
    }
}
