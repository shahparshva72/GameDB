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

    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Welcome to GamingQuest", description: "Your personal video game tracker and explorer", imageName: "gamecontroller"),
        OnboardingPage(title: "Track Your Games", description: "Save games you've played, want to play, or are currently playing", imageName: "list.bullet.clipboard"),
        OnboardingPage(title: "Discover New Games", description: "Explore a vast library of games across different categories", imageName: "magnifyingglass"),
        OnboardingPage(title: "Stay Updated", description: "Get the latest gaming news from popular feeds", imageName: "newspaper"),
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.black, .black.opacity(0.8)]),
                    startPoint: .topTrailing,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    ZStack {
                        ForEach(0 ..< pages.count, id: \.self) { index in
                            if currentPage == index {
                                OnboardingPageView(page: pages[index])
                                    .transition(.opacity.combined(with: .scale))
                                    .scaleEffect(currentPage == index ? 1 : 0.8)
                                    .offset(x: CGFloat(index - currentPage) * geometry.size.width + dragOffset)
                            }
                        }
                    }
                    .padding(.all)
                    .gesture(
                        DragGesture()
                            .onChanged { value in dragOffset = value.translation.width }
                            .onEnded { value in
                                let threshold = geometry.size.width * 0.2
                                if value.translation.width > threshold, currentPage > 0 {
                                    withAnimation(.spring()) { currentPage -= 1 }
                                } else if value.translation.width < -threshold, currentPage < pages.count - 1 {
                                    withAnimation(.spring()) { currentPage += 1 }
                                }
                                dragOffset = 0
                            }
                    )

                    Spacer()

                    ProgressBar(progress: CGFloat(currentPage + 1) / CGFloat(pages.count))
                        .frame(width: geometry.size.width * 0.6, height: 10)
                        .padding(.bottom, 20)

                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation(.spring()) { currentPage += 1 }
                        }) {
                            Text("Next")
                                .pixelatedFont(size: 14)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 50)
                    } else {
                        Button(action: {
                            isOnboardingComplete = true
                        }) {
                            Text("Get Started")
                                .pixelatedFont(size: 14)
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [.purple, .purple.opacity(0.8)]
                                        ),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(10)
                                .scaleEffect(1.1)
                        }
                        .padding(.bottom, 50)
                        .scaleEffect(1.05)
                        .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: currentPage)
                    }
                }
            }
        }
    }
}

// Onboarding Page model and OnboardingPageView
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
                .padding()
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 4)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .animation(.easeInOut(duration: 0.6), value: isAnimating)

            Text(page.title)
                .pixelatedFont(size: 20)
                .foregroundColor(.white)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5).delay(0.3), value: isAnimating)

            Text(page.description)
                .pixelatedFont(size: 14)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5).delay(0.4), value: isAnimating)
        }
        .onAppear { isAnimating = true }
        .onDisappear { isAnimating = false }
    }
}

// Custom Progress Bar View
struct ProgressBar: View {
    var progress: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)

            Capsule()
                .fill(Color.purple)
                .frame(width: progress * 200, height: 10)
                .animation(.easeInOut(duration: 0.6), value: progress)
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
