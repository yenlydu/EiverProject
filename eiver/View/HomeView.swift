//
//  SwiftUIView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import SwiftUI

struct HomeView : View {
    @StateObject private var homeViewModel : HomeViewModel

    init(viewModel: HomeViewModel = .init()) {
        _homeViewModel = StateObject(wrappedValue: viewModel)
    }

    var searchField: some View {
        HStack{
            TextField("Search film", text:$homeViewModel.textInput)
        }.padding().background(Color(.systemGray6)).cornerRadius(15).padding(.horizontal)
    }
    
    var filmList: some View{
        ZStack(alignment: .leading){
            Form {
                Section {
                    List {
                        ForEach(homeViewModel.films.filter({"\($0.original_title)".contains(homeViewModel.textInput) || homeViewModel.textInput.isEmpty}), id:\.self) { film in
                            VStack(alignment: .center){
                                Button (action: {
                                    homeViewModel.clickedRow = film
                                    homeViewModel.goToSubBoard.toggle()
                                }) {
                                    Text(film.original_title).font(.system(size: 20, weight: .heavy) )
                                    }.keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/).foregroundColor(Color.black).textFieldStyle(RoundedBorderTextFieldStyle()).frame(alignment: .center)
                            }
                        }.frame(height: 70)
                    }
                }
            } .background(Color.yellow).listRowInsets(EdgeInsets())
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                searchField
                filmList
                if (homeViewModel.goToSubBoard) {
                    NavigationLink(destination: FilmDetailView(film: homeViewModel.clickedRow).navigationBarTitle(Text(homeViewModel.clickedRow!.original_title), displayMode: .inline), isActive: $homeViewModel.goToSubBoard) {}
                }
            }.onAppear(perform: homeViewModel.getFilms)}
    }

}
