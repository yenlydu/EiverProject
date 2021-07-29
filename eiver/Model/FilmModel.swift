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
}

protocol DataService {
    func loadData(_ completionHandler: @escaping(_ genres: [Film]?) -> ())
}

class GetFilms : ObservableObject, DataService {
    func loadPages(nb: String, _ completionHandler: @escaping(_ genres: [Film]?) -> ()){
        var books: [Film] = []
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) in
                guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=b5c692622885db92d8a2eaa07c8e096c&primary_release_year=2017&sort_by=revenue.desc&page=\(nb)") else {
    // http://api.themoviedb.org/3/movie/181808/videos?api_key=b5c692622885db92d8a2eaa07c8e096c
                print("Invalid url...")
                return
            }
            var movieData = [String: Any]()
            
            URLSession.shared.dataTask(with: url) { data, response, error in

                guard let data = data, error == nil else { return }
                do {
                    movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//                    print ("data ", movieData)
//                    print ("mvdata: ",movieData["page"])
                    let jsonData = try JSONSerialization.data(withJSONObject: movieData["results"], options: [])
                    books = try! JSONDecoder().decode([Film].self, from: jsonData)
                    print (books)
                    return completionHandler(books)

                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        })


        
    }

    func forloop(temp: Int!, books: [Film], completionHandler: @escaping(_ genres: [Film]?) -> ())
    {
        var b = books
        let myGroup = DispatchGroup()
        myGroup.enter()

        for i in 2...temp{
                self.loadPages(nb: String(i),{[weak self] film in
                                                if let film = film {
                                                    b += film ?? []
                    }
                })

        }
        myGroup.leave()
        myGroup.wait()
        myGroup.notify(queue: .main) {
            print (b.count)
            completionHandler(b)

            print("Finished all requests.")
        }
    }
    func loadData(_ completionHandler: @escaping(_ genres: [Film]?) -> ()){
        var books: [Film] = []
            print("entered load data")
                guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=b5c692622885db92d8a2eaa07c8e096c") else {
    // http://api.themoviedb.org/3/movie/181808/videos?api_key=b5c692622885db92d8a2eaa07c8e096c
                print("Invalid url...")
                return
            }
            var movieData = [String: Any]()
            
        URLSession.shared.dataTask(with: url) { [self] data, response, error in

                guard let data = data, error == nil else { return }
                do {
                    movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//                    print (movieData["total_pages"])
                    let jsonData = try JSONSerialization.data(withJSONObject: movieData["results"], options: [])
                    var testing : [Film] = []
                    let temp: Int!
                    temp = movieData["total_pages"] as! Int
                    books = try! JSONDecoder().decode([Film].self, from: jsonData)
//                    forloop(temp: temp, books: books, completionHandler: {[weak self] film in
//                        if let film = film {
//                            books += film
//                            testing = books
//                            print("entered", testing.count)
//                        }
//                    })
//                    print("enter", movieData["results"])
//                    print ("testinggg",books[0].original_title)
//                    print ("testinggg",books[0].release_date)
                        return completionHandler(books)



                } catch let error as NSError {
                    print(error)
                }
            }.resume()
        
    }
}
