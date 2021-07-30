//
//  HomeViewModel.swift
//  eiver
//
//  Created by Duong Yen-Ly on 25/07/2021.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var films = [Film]()
    @Published var textInput = ""
    @Published  var clickedRow: Film? = nil
    @Published var goToSubBoard: Bool = false

    private let api : DataService

    init(dataService: DataService = GetFilms()) {
        self.api = dataService
    }

    func getFilms() {
        var timer: Timer?
        let group = DispatchGroup()
        api.loadData({[weak self] film in
            timer = Timer.scheduledTimer(
                withTimeInterval: 0.01,
                repeats: true
            ) { _ in            group.enter()
            if let film = film {
                group.leave()
                group.notify(queue: .main) {
                    self!.films = film
                }
            }
            }
        })
        self.objectWillChange.send()

    }
}
 
