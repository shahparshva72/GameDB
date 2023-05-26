//
//  GameThumbnail.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import SwiftUI
import Combine

class DominantColorProvider: ObservableObject {
    @Published var dominantColor: Color?
    private var kMeansClusterer = KMeansClusterer()
    
    func findDominantColor(for image: UIImage?) {
        guard let image = image else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let smallImage = image.resized(to: CGSize(width: 100, height: 100))
            let points = smallImage.getPixels().map({ KMeansClusterer.Point(from: $0) })
            let clusters = self.kMeansClusterer.cluster(points: points, into: 3).sorted(by: {$0.points.count > $1.points.count})
            let colors = clusters.map(({$0.center.toUIColor()}))
            
            guard let mainColor = colors.first else {
                return
            }
            
            DispatchQueue.main.async {
                self.dominantColor = Color(mainColor)
            }
        }
    }
}

struct GameThumbnail: View {
    var game: GameModel
    @State private var dominantColor: Color = Color.white
    var body: some View {
        VStack {
            AsyncImage(url: game.coverURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .cornerRadius(15)
            .shadow(color: dominantColor, radius: 10, x: 0.0, y: 0.0)
            .onAppear {
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let url = URL(string: game.coverURLString),
                          let data = try? Data(contentsOf: url),
                          let uiImage = UIImage(data: data) else { return }
                    
                    let smallImage = uiImage.resized(to: CGSize(width: 100, height: 100))
                    let kMeans = KMeansClusterer()
                    let points = smallImage.getPixels().map({ KMeansClusterer.Point(from: $0) })
                    let clusters = kMeans.cluster(points: points, into: 3).sorted(by: { $0.points.count > $1.points.count })
                    let uiColors = clusters.map({ $0.center.toUIColor() })
                    
                    guard let mainUIColor = uiColors.first else { return }
                    
                    DispatchQueue.main.async {
                        dominantColor = Color(mainUIColor)
                    }
                }
            }
            HStack(alignment: .top){
                VStack(alignment: .leading) {
                    Text(game.name)
                        .font(.headline)
                    Text(game.releaseDateText)
                        .font(.subheadline)
                    Text(game.company)
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .padding(EdgeInsets.init(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background(Rectangle()
                .foregroundColor(dominantColor)
                .opacity(0.6)
                .blur(radius: 2.5))
        }
        .padding(10)
        .background(dominantColor)
        .cornerRadius(20)
        .shadow(color: dominantColor.opacity(0.3), radius: 20, x: 0.0, y: 0.0)
    }
}
