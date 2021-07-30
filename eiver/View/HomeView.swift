//
//  SwiftUIView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import SwiftUI


struct HomeView: View {
    @StateObject var homeViewModel : HomeViewModel

    init(viewModel: HomeViewModel = .init()) {
        _homeViewModel = StateObject(wrappedValue: viewModel)
    }
    @State private var textInput = ""
    @State private var clickedRow: Film? = nil
    @State private var goToSubBoard: Bool = false

    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    TextField("Search film", text:$textInput)
                }.padding().background(Color(.systemGray6)).cornerRadius(15).padding(.horizontal)
                ZStack(alignment: .leading){
                    Form {
                        Section {
                            List {
                                ForEach(homeViewModel.films.filter({"\($0.original_title)".contains(textInput) || textInput.isEmpty}), id:\.self) { film in
                                    VStack(alignment: .center){
                                        Button (action: {
                                            self.clickedRow = film
                                            self.goToSubBoard.toggle()
                                        }) {
                                            Text(film.original_title).font(.system(size: 20, weight: .heavy) )
                                            }.keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/).foregroundColor(Color.black).textFieldStyle(RoundedBorderTextFieldStyle()).frame(alignment: .center)
                                    }
                                }.frame(height: 70)
                            }
                        }
                    } .background(Color.yellow).listRowInsets(EdgeInsets())
                }
                if (goToSubBoard) {
                    NavigationLink(destination: FilmDetailView(film: clickedRow).navigationBarTitle(Text(clickedRow!.original_title), displayMode: .inline), isActive: $goToSubBoard) {}
                }
            }.onAppear(perform: homeViewModel.getFilms)}
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

