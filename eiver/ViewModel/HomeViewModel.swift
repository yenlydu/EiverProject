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
            group.enter()
            var t : [Film] = []
            api.loadData({[weak self] film in
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
            films = t
        }
    }
}

