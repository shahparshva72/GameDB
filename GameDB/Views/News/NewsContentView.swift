//
//  NewsContentView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/14/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct NewsContentView: View {
    let urlString: String
    
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(.all)
            
            WebView(urlString: urlString)
                .opacity(isLoading ? 0.0 : 1.0)
                .transition(.opacity.animation(.easeInOut(duration: 1.0)))
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2, anchor: .center)
                    .transition(.scale.animation(.easeInOut(duration: 1.0)))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}
