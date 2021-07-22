//
//  SwiftUIView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 18/07/2021.
//

import SwiftUI


struct HomeView: View {
    
    let ar = ["er", "éaee", "dsge","er", "éaee", "dsge","er", "éaee", "dsge","er", "éaee", "dsge"]
    var films: [Film] = []
    @State var clickedRow: Film? = nil
    @State var goToSubBoard: Bool = false

    var body: some View {
        NavigationView{
            VStack{
                
        ZStack{
            
            Form {
                Section {
                    List {
                        ForEach(Array(films.enumerated()), id: \.1.id) { (index, textItem) in
                            VStack(alignment: .center){
                                Button (action: {
                                    self.clickedRow = films[index]
                                    self.goToSubBoard.toggle()

                                }) {
                                    Text(films[index].original_title)
                                    }.keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/).foregroundColor(Color.black).textFieldStyle(RoundedBorderTextFieldStyle()).frame(alignment: .center)                                }
                            }.frame(height: 70)
                        }
                    }
                }
            }
            if (goToSubBoard){
                NavigationLink(destination: ContentViewbIS(film: clickedRow), isActive: $goToSubBoard) {}
            }            }


    }
        Text(String(goToSubBoard))
    }


    init(t: [Film]) {
        self.films = t
        print("dezfazef + ",films[4].original_title)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(t: [])
    }
}

