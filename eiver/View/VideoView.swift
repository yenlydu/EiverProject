//
//  VideoView.swift
//  eiver
//
//  Created by Duong Yen-Ly on 29/07/2021.
//

import Foundation
import WebKit
import SwiftUI

struct VideoView: UIViewRepresentable {
    let videoId: String
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print ("videoId ", videoId)
        let player = URL(string: "https://www.youtube.com/embed/\(videoId)")!
        uiView.layer.cornerRadius = 25
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: player))
        uiView.layer.masksToBounds = true

    }
}
