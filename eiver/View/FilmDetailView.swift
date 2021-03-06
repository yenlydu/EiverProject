//
//  ContentViewbIS.swift
//  eiver
//
//  Created by Duong Yen-Ly on 22/07/2021.
//
import SwiftUI

/*
 View: Construct film detail view (information on the clicked film, poster, release date, synopsis and some trailers)
*/
struct FilmDetailView: View {
    @StateObject var filmDetailViewModel: FilmDetailViewModel
    
    init(film: Film?, filmDetailViewModel: FilmDetailViewModel = .init()) {
        _filmDetailViewModel = StateObject(wrappedValue: filmDetailViewModel)
        filmDetailViewModel.film = film
        guard let url = URL(string: "https://image.tmdb.org/t/p/original/\(film!.poster_path)") else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            //BEFORE: was loading image view synchrounously within the same thread (commented section), now: loading it asynchrounously
            DispatchQueue.main.async {
                filmDetailViewModel.image = UIImage(data: data)!
            }

            }.resume()
//        let url = URL(string: )!
//        let data = try? Data(contentsOf: url)
//        //Le chargement de l'image est en synchrone, ce qui fait que la page prend du temps a charger
//        if let imageData = data {
//            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            }
//        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                LazyVStack {
                    Image(uiImage: filmDetailViewModel.image ?? UIImage())
                        .resizable().cornerRadius(10).padding()
                        .frame(width: 180.0, height: 240.0)
                    LazyHStack{
                        Text("Release date : ").font(.system(size: 20))
                        Text (filmDetailViewModel.film!.release_date ?? "No release date").italic()
                    }.padding(.bottom)
                    Text(filmDetailViewModel.film?.overview ?? "No description").padding()

                    ScrollView(.vertical, showsIndicators: false) {
                        TabView(selection: $filmDetailViewModel.index) {
                            ForEach((filmDetailViewModel.film?.youtubeTrailer?.indices)!) { index in
                                VideoView(videoId: (filmDetailViewModel.film?.youtubeTrailer?[index].key)!).tag(index)
                            }

                        }.tabViewStyle(PageTabViewStyle()).frame(width: UIScreen.main.bounds.width * 0.9,height:150)
                    }

                }
            }
        }.frame(width: UIScreen.main.bounds.width).background(Color(filmDetailViewModel.image?.averageColor ?? .black).opacity(0.3).edgesIgnoringSafeArea(.all))
    }
}
