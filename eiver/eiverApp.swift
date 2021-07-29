//
//  eiverApp.swift
//  eiver
//
//  Created by Duong Yen-Ly on 16/07/2021.
//

import SwiftUI


@main
struct eiverApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        UINavigationBar.appearance().standardAppearance = appearance

    }
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }

}
