//
//  FilmModel.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import Foundation

struct Film: Codable, Identifiable, Hashable {
    let id : Int
    var original_title: String
    var overview: String
    var release_date: String
}
