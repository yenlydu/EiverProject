//
//  ContentView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 16/07/2021.
//

import SwiftUI
import UIKit




struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("enter")
        }.navigationBarTitle(Text("Search")).onAppear(){
            NavigationLink(destination: HomeView(films: [])) {}
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
