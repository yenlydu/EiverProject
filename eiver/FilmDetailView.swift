//
//  ContentViewbIS.swift
//  eiver
//
//  Created by Duong Yen-Ly on 22/07/2021.
//
import SwiftUI

protocol DataServiceYtb
{
    func loadData(id: String, _ completionHandler: @escaping(_ genres: [FilmYoutubeVideo]?) -> ())
}

struct FilmYoutubeVideo: Codable, Identifiable, Hashable
{
    let id : String
    var key: String
    var name: String
    var type: String
    var published_at: String
}

class GetYtb : ObservableObject, DataServiceYtb
{
    
    func loadData(id: String, _ completionHandler: @escaping(_ genres: [FilmYoutubeVideo]?) -> ()){
        var books: [FilmYoutubeVideo] = []
            print("entered load ytb", "http://api.themoviedb.org/3/movie/\(id)/videos?api_key=b5c692622885db92d8a2eaa07c8e096c")
                guard let url = URL(string: "http://api.themoviedb.org/3/movie/\(id)/videos?api_key=b5c692622885db92d8a2eaa07c8e096c") else {
    // http://api.themoviedb.org/3/movie/181808/videos?api_key=b5c692622885db92d8a2eaa07c8e096c
                print("Invalid url...")
                return
            }
            var movieData = [String: Any]()
            
        URLSession.shared.dataTask(with: url) { data, response, error in

                guard let data = data, error == nil else {
                    return
                }
                do {
                    movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: movieData["results"], options: [])
                    books = try! JSONDecoder().decode([FilmYoutubeVideo].self, from: jsonData)
                    print (books)

//                    print ("entering moviedata ", movieData["results"])
                    return completionHandler(books)
                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        
    }

}



struct FilmDetailView: View {
    
    private var film: Film?
    private var image : UIImage?

    init(film: Film?) {
        self.film = film
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(film!.poster_path)")!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            self.image = UIImage(data: imageData)!
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
        ZStack {
            Color(image?.averageColor ?? .black).opacity(0.3).ignoresSafeArea()
          VStack {
            Image(uiImage: image ?? UIImage())
                .resizable()        .cornerRadius(10).padding()
                .frame(width: 180.0, height: 240.0)

            HStack{
                Text("Release date : ").font(.system(size: 20))
                Text (film!.release_date).italic()
            }.padding(.bottom)
            Text(film?.overview ?? "No description").padding()
            if (film?.youtubeTrailer?.count != 0) {
                TrailersCaroussel(trailers: (film?.youtubeTrailer!)!)
           }
          }
          } // VStack
        } // ZStack
    }
}

struct FilmDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FilmDetailView(film: nil)
    }
}
