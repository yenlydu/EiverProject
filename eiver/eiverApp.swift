//
//  eiverApp.swift
//  eiver
//
//  Created by Duong Yen-Ly on 16/07/2021.
//

import SwiftUI

class Api : ObservableObject {
    func loadData(_ completionHandler: @escaping(_ genres: [Film]?) -> ()){
        var books: [Film] = []
        print("entered load data")
            guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=b5c692622885db92d8a2eaa07c8e096c&primary_release_year=2017&sort_by=revenue.desc") else {
// http://api.themoviedb.org/3/movie/181808/videos?api_key=b5c692622885db92d8a2eaa07c8e096c
            print("Invalid url...")
            return
        }
        var movieData = [String: Any]()
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else { return }
            do {
                movieData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let jsonData = try JSONSerialization.data(withJSONObject: movieData["results"], options: [])
                books = try! JSONDecoder().decode([Film].self, from: jsonData)
                return completionHandler(books)

            } catch let error as NSError {
                print(error)
            }
        }.resume()
        
    }
}

@main
struct eiverApp: App {
    var film: [Film] = []
    init() {
        
        let group = DispatchGroup()
        group.enter()


        let test = Api()
        var t : [Film] = []
        test.loadData({film in
            if let film = film {
                t = film
                print ("leavz")
                group.leave()
            }
        })
        group.wait()
        
        group.notify(queue: .main) {
            print("ezrf", t.count)
        }
        film = t
        print("ezrf", film.count)

    }
    var body: some Scene {
        WindowGroup {
            HomeView(t: film)
        }
    }

}
