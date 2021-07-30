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

class GetFilms : ObservableObject, DataService {
    func loadPages(nb: String, _ completionHandler: @escaping(_ genres: [Film]?) -> ()){
        var books: [Film] = []
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) in
                guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=b5c692622885db92d8a2eaa07c8e096c&page=\(nb)") else {
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
     Retrieve all movies pages
    */

    func forloop(moviePages: Int!, books: [Film], completionHandler: @escaping(_ genres: [Film]?) -> ())
    {
        var b = books
        let myGroup = DispatchGroup()
        myGroup.enter()

        for i in 2...moviePages {
                self.loadPages(nb: String(i), { film in
                        if let film = film {
                            b += film
                        }
                    }
                )

        }
        myGroup.leave()
        myGroup.wait()
        myGroup.notify(queue: .main) {
            completionHandler(b)
            print("Requests: Got all movies pages.")
        }
    }
    
    /**
     Calls TMDB api's to retrieve youtube trailers for each films
    */
    func loadYoutubeTrailers(books: [Film], completionHandler: @escaping(_ genres: [Film]?)->())
    {
        var tempBooks = books
        let group = DispatchGroup()
        let api = GetYtb()
        for i in 0...(tempBooks.count - 1) {
            group.enter()
            api.loadData(id: String(tempBooks[i].id), {film in
                if let film = film {
                    tempBooks[i].youtubeTrailer = film
                    group.leave()
                }
            })
        }
        group.notify(queue: .main) {
            print("Requests: Loaded movies youtube trailers.")
            completionHandler(tempBooks)
        }

    }

    /**
     Load all types of datas (movies, youtube trailers)
    */
    func loadData(_ completionHandler: @escaping(_ genres: [Film]?) -> ()){
        var books: [Film] = []
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
                    books = try! JSONDecoder().decode([Film].self, from: jsonData)
                    print (books.count)
//                    let moviePages: Int!
//                    moviePages = (movieData["total_pages"] as! Int)
//                    forloop(moviePages: moviePages, books: books, completionHandler: {[weak self] film in
//                        if let film = film {
//                            books += film
//                        }
//                    })
                    //Load youtube trailers and store datas
                    loadYoutubeTrailers(books: books, completionHandler: {film in
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
