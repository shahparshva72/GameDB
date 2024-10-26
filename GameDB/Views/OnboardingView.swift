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
    @State private var dragOffset: CGFloat = 0
    @State private var buttonOpacity: Double = 1

    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Welcome to GamingQuest", description: "Your personal video game tracker and explorer", imageName: "gamecontroller"),
        OnboardingPage(title: "Track Your Games", description: "Save games you've played, want to play, or are currently playing", imageName: "list.bullet.clipboard"),
        OnboardingPage(title: "Discover New Games", description: "Explore a vast library of games across different categories", imageName: "magnifyingglass"),
        OnboardingPage(title: "Stay Updated", description: "Get the latest gaming news from popular feeds", imageName: "newspaper"),
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black).ignoresSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()
                    ZStack {
                        ForEach(0 ..< pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .opacity(currentPage == index ? 1 : 0)
                                .scaleEffect(currentPage == index ? 1 : 0.8)
                                .offset(x: CGFloat(index - currentPage) * geometry.size.width + dragOffset, y: 0)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold = geometry.size.width * 0.2
                                if value.translation.width > threshold, currentPage > 0 {
                                    withAnimation(.spring()) {
                                        currentPage -= 1
                                        dragOffset = 0
                                    }
                                } else if value.translation.width < -threshold, currentPage < pages.count - 1 {
                                    withAnimation(.spring()) {
                                        currentPage += 1
                                        dragOffset = 0
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )

                    Spacer()

                    PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                        .padding(.top)

                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            if currentPage < pages.count - 1 {
                                withAnimation(.spring()) {
                                    currentPage += 1
                                }
                            } else {
                                isOnboardingComplete = true
                            }
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
                    .opacity(buttonOpacity)
                }
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
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5).delay(0.2), value: isAnimating)

            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 20)
                .animation(.easeInOut(duration: 0.5).delay(0.4), value: isAnimating)

            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 20)
                .animation(.easeInOut(duration: 0.5).delay(0.6), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

struct PageControl: View {
    let numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< numberOfPages, id: \.self) { page in
                Circle()
                    .fill(page == currentPage ? Color.white : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .scaleEffect(page == currentPage ? 1.2 : 1.0)
                    .animation(.spring(), value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
