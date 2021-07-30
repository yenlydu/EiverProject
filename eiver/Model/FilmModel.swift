//
//  FilmModel.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import Foundation
import UserNotifications

struct Film: Codable, Identifiable, Hashable {
    let id : Int
    var original_title: String
    var overview: String
    var release_date: String
    var poster_path: String
    var youtubeTrailer: [FilmYoutubeVideo]?
}

protocol DataService {
    func loadData(_ completionHandler: @escaping(_ genres: [Film]?) -> ())
}

/**
 Class that retrieve all films from the TMDB api
*/
class GetFilms : ObservableObject, DataService {
    /**
        Api call to get all the specificied page movies
    */
    func loadPages(page: String, _ completionHandler: @escaping(_ genres: [Film]?) -> ()){
        var books: [Film] = []
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) in
                guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=b5c692622885db92d8a2eaa07c8e096c&page=\(page)") else {
                print("Invalid url...")
                return
            }
            var movieData = [String: Any]()

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                do {
                    movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: movieData["results"]!, options: [])
                    books = try! JSONDecoder().decode([Film].self, from: jsonData)

                    return completionHandler(books)
                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        })
    }

    /**
     Loop over the pages and retrieve all movie's pages
    */
    func forloop(moviePages: Int!, films: [Film], completionHandler: @escaping(_ genres: [Film]?) -> ())
    {
        var films = films
        let myGroup = DispatchGroup()
        myGroup.enter()

        for page in 2...moviePages {
                self.loadPages(page: String(page), { film in
                        if let film = film {
                            films += film
                        }
                    }
                )
        }
        myGroup.leave()
        myGroup.wait()
        myGroup.notify(queue: .main) {
            completionHandler(films)
            print("Requests: Got all movies pages.")
        }
    }
    
    /**
     Calls TMDB api's to retrieve youtube trailers for each films
    */
    /**
     Load all types of datas (movies, youtube trailers)
    */
    func loadData(_ completionHandler: @escaping(_ genres: [Film]?) -> ()){
        var films: [Film] = []
            print("entered load data")
                guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=b5c692622885db92d8a2eaa07c8e096c") else {
                print("Invalid url...")
                return
            }
            var movieData = [String: Any]()
            
        URLSession.shared.dataTask(with: url) { [self] data, response, error in

                guard let data = data, error == nil else { return }
                do {
                    movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: movieData["results"] as Any, options: [])
                    let youtubeTrailersApi = GetTrailers()
                    films = try! JSONDecoder().decode([Film].self, from: jsonData)
//                    let moviePages: Int!
//                    moviePages = (movieData["total_pages"] as! Int)
//                    forloop(moviePages: moviePages, books: books, completionHandler: {[weak self] film in
//                        if let film = film {
//                            books += film
//                        }
//                    })
                    //Load youtube trailers and store datas
                    youtubeTrailersApi.loadYoutubeTrailers(films: films, completionHandler: {film in
                        if let film = film {
                            completionHandler(film)
                        }
                    })
                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        
    }
}
