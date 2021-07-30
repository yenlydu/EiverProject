//
//  FilmsDetailView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import SwiftUI
struct TrailersCaroussel: View {
    private var trailers: [FilmYoutubeVideo]
    @State var index = 0

    init(trailers: [FilmYoutubeVideo]) {
        self.trailers = trailers
        UITabBar.appearance().backgroundColor = UIColor.red
    }
    
    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            TabView(selection: $index) {
                ForEach(trailers.indices) { index in
                    VideoView(videoId: trailers[index].key).tag(index)
                }
            }.tabViewStyle(PageTabViewStyle()).frame(width: UIScreen.main.bounds.width * 0.9,height:150)
        }
    }
}

struct TrailersCaroussel_Previews: PreviewProvider {
    static var previews: some View {
        TrailersCaroussel(trailers: [])
    }
}
