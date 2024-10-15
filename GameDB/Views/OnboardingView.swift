//
//  OnboardingView.swift
//  GameDB
//
//  Created by Parshva Shah on 10/14/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Welcome to GameDB", description: "Your personal video game tracker and explorer", imageName: "gamecontroller"),
        OnboardingPage(title: "Track Your Games", description: "Save games you've played, want to play, or are currently playing", imageName: "list.bullet.clipboard"),
        OnboardingPage(title: "Discover New Games", description: "Explore a vast library of games across different categories", imageName: "magnifyingglass"),
        OnboardingPage(title: "Stay Updated", description: "Get the latest gaming news from popular feeds", imageName: "newspaper")
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                    } else {
                        isOnboardingComplete = true
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}

