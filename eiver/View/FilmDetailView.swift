//
//  ContentViewbIS.swift
//  eiver
//
//  Created by Duong Yen-Ly on 22/07/2021.
//
import SwiftUI

struct FilmDetailView: View {
    @StateObject var filmDetailViewModel: FilmDetailViewModel

    init(film: Film?, filmDetailViewModel: FilmDetailViewModel = .init()) {
        _filmDetailViewModel = StateObject(wrappedValue: filmDetailViewModel)
        filmDetailViewModel.film = film
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(film!.poster_path)")!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            filmDetailViewModel.image = UIImage(data: imageData)!
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    Image(uiImage: filmDetailViewModel.image ?? UIImage())
                        .resizable().cornerRadius(10).padding()
                        .frame(width: 180.0, height: 240.0)
                    HStack{
                        Text("Release date : ").font(.system(size: 20))
                        Text (filmDetailViewModel.film!.release_date).italic()
                    }.padding(.bottom)
                    Text(filmDetailViewModel.film?.overview ?? "No description").padding()
                    if (filmDetailViewModel.film?.youtubeTrailer?.count != 0) {
                        TrailersCaroussel(trailers: (filmDetailViewModel.film?.youtubeTrailer!)!)
                   }
                }
            }
        }.frame(width: UIScreen.main.bounds.width).background(Color(filmDetailViewModel.image?.averageColor ?? .black).opacity(0.3).edgesIgnoringSafeArea(.all)
)
    }
}
