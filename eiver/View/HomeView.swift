//
//  SwiftUIView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 25.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(fractionCompleted))
                .stroke(strokeColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
/*
 View: Construct home page (search bar for films and films retrieved from the API)
*/
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
            } .background(Color.yellow).listRowInsets(EdgeInsets()).onAppear(){
                homeViewModel.getFilms()

            }
        }
    }
    
    @State private var progress = 0.2
    var body: some View {
        NavigationView{
            VStack{
                searchField
                filmList

                if (homeViewModel.goToSubBoard) {
                    NavigationLink(destination: FilmDetailView(film: homeViewModel.clickedRow).onDisappear(){ProgressView().hidden()}.onTapGesture{
                        
                    }.navigationBarTitle(Text(homeViewModel.clickedRow!.original_title), displayMode: .inline), isActive: $homeViewModel.goToSubBoard) {

                    }
                }
            }
    }
    }}
