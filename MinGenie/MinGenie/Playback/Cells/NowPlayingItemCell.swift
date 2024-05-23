import MusicKit
import SwiftUI

/// ✏️ 현재 재생 화면 정사각형 곡 cell ✏️
///  ✅ 디자인 세부 조정 필요

struct NowPlayingItemCell: View {
    // MARK: - Constants
    private static let defaultArtworkSize = 264.0
    private static let defaultArtworkCornerRadius = 16.0
    
    // MARK: - Initialization
    
    init(
        artwork: Artwork? = nil,
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.artwork = artwork
        self.title = (title ?? "")
        self.subtitle = (subtitle ?? "")
    }
    
    // MARK: - Properties
    let artwork: Artwork?
    let title: String
    let subtitle: String
    
    var artworkSize: CGFloat = defaultArtworkSize
    var artworkCornerRadius: CGFloat = defaultArtworkCornerRadius
    var subtitleVerticalOffset: CGFloat = -2
    
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            VStack {
                if let itemArtwork = artwork {
                    ZStack {
                        imageContainer(for: itemArtwork)
                            .frame(width: artworkSize, height: artworkSize)
                            .shadow(radius: artworkCornerRadius)
                        
                    }
                }
                
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                    .font(.system(size: 24))
                
                Text(subtitle)
                    .font(.system(size: 16))
                
                Spacer()
            }
            .padding(.top)
        }
    

    }
    
    private func imageContainer(for artwork: Artwork) -> some View {
        VStack {
            Spacer()
            ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                .cornerRadius(artworkCornerRadius)
            Spacer()
        }
    }
    
   
}
