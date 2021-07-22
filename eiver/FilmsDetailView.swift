//
//  FilmsDetailView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import SwiftUI
struct FilmsDetailView: View {
    var film: Film?

    init(film: Film? = nil) {
        self.film = film
    }
    
    var body: some View {
        Text(String( film?.id ?? 0))
        Text(String( film?.original_title ?? "Nothing to display"))
    }
}

struct FilmsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FilmsDetailView()
    }
}
