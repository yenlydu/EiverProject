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
        private let api : DataService
        
        init(dataService: DataService = GetFilms()) {
            self.api = dataService
        }

        func getFilms(){
            let group = DispatchGroup()
            api.loadData({[weak self] film in
                group.enter()
                if let film = film {
                    group.leave()
                    group.notify(queue: .main) {
                        self!.films = film
                    }
                }
            })

        }
    }
}

