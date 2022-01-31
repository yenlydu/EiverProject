//
//  TrailerModel.swift
//  eiver
//
//  Created by Duong Yen-Ly on 30/07/2021.
//
import Foundation

struct FilmYoutubeVideo: Codable, Identifiable, Hashable
{
    let id : String
    var key: String
    var name: String
    var type: String
    var published_at: String
}

/**
 Model: Retrieves trailers from the TMDB api
*/

class GetTrailers : ObservableObject, DataServiceYtb
{
    func callTrailersApi(id: String, _ completionHandler: @escaping(_ genres: [FilmYoutubeVideo]?) -> ()){
            guard let url = URL(string: "http://api.themoviedb.org/3/movie/\(id)/videos?api_key=b5c692622885db92d8a2eaa07c8e096c")
            else {
                print("Invalid url...")
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, response != nil, error == nil else {return}
                do {
                    var films: [FilmYoutubeVideo] = []
                    let movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]

                    films = try! JSONDecoder().decode([FilmYoutubeVideo].self, from: try JSONSerialization.data(withJSONObject: movieData["results"]!, options: []))
                    return completionHandler(films)
                } catch let error as NSError {
                    print(error)
                    completionHandler([])
                }
            }.resume()
    }

    func loadYoutubeTrailers(films: [Film], completionHandler: @escaping(_ genres: [Film]?)->())
    {
        var tempFilms = films
        let group = DispatchGroup()

        for i in 0...(tempFilms.count - 1) {
            group.enter()
            callTrailersApi(id: String(tempFilms[i].id), {film in
                if let film = film {
                    tempFilms[i].youtubeTrailer = film
                    group.leave()
                }
            })
        }
        group.notify(queue: .main) {
            print("Requests: Loaded movies youtube trailers.")
            return completionHandler(tempFilms)
        }
    }
}

protocol DataServiceYtb
{
    func loadYoutubeTrailers(films: [Film], completionHandler: @escaping(_ genres: [Film]?)->())
    func callTrailersApi(id: String, _ completionHandler: @escaping(_ genres: [FilmYoutubeVideo]?) -> ())
}
