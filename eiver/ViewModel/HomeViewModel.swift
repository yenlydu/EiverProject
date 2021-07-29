//
//  HomeViewModel.swift
//  eiver
//
//  Created by Duong Yen-Ly on 25/07/2021.
//

import Foundation

extension HomeView{
    class HomeViewModel: ObservableObject{
        @Published var films = [Film]()
        let api : DataService
        
        init(dataService: DataService = GetFilms()) {
            self.api = dataService
        }

        func getFilms(){
            print("entering group")
            let group = DispatchGroup()
            var t : [Film] = []
            api.loadData({[weak self] film in
                group.enter()
                if let film = film {
                    t = film
                    print ("film[0].youtubeTrailer?.count", film[0].youtubeTrailer?.count)
                    print ("leavz")
                    group.leave()
                    group.notify(queue: .main) {
                        print("ezrf", t.count)
                        self!.films = t
                        print ("t" , t[0].youtubeTrailer?.count)
                    }
                }
            })

        }
    }
}

