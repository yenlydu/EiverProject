//
//  FilmDetailViewModel.swift
//  eiver
//
//  Created by Duong Yen-Ly on 30/07/2021.
//

import Foundation
import SwiftUI

/*
 ViewModel: View Model for FilmDetailView.swift
*/
class FilmDetailViewModel : ObservableObject {
    @Published var film: Film?
    @Published var image : UIImage?
    @Published var trailers: [FilmYoutubeVideo] = []
    @Published var index = 0

    init() {
    }
}
