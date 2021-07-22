//
//  ContentViewbIS.swift
//  eiver
//
//  Created by Duong Yen-Ly on 22/07/2021.
//

import SwiftUI

struct ContentViewbIS: View {
    var film: Film?
    init(film: Film?) {
        self.film = film
    }
    var body: some View {
        Text(film?.original_title ?? "Nil")
    }
}

struct ContentViewbIS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewbIS(film: nil)
    }
}
