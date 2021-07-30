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
    @State var clickedRow: Film? = nil
    @State var goToSubBoard: Bool = false
    var destination: AnyView? = nil
    var body: some View {
        NavigationView{
            VStack{
                
        ZStack{
            
            Form {
                Section {
                    List {
                        ForEach(Array(homeViewModel.films.enumerated()), id: \.1.id) { (index, textItem) in
                            VStack(alignment: .center){
                                Button (action: {
                                    self.clickedRow = homeViewModel.films[index]
                                    self.goToSubBoard.toggle()


                                }) {
                                    Text(homeViewModel.films[index].original_title).font(.system(size: 20, weight: .heavy) )
                                    }.keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/).foregroundColor(Color.black).textFieldStyle(RoundedBorderTextFieldStyle()).frame(alignment: .center)                                }
                            }.frame(height: 70)
                    }
                    }
                }
            }
            if (goToSubBoard) {

                NavigationLink(destination: ContentViewbIS(film: clickedRow).navigationBarTitle(Text(clickedRow!.original_title), displayMode: .inline), isActive: $goToSubBoard) {}
            }
            }.onAppear(perform: homeViewModel.getFilms)}
    }

    var defaultView: some View{
        Text("empty view")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

