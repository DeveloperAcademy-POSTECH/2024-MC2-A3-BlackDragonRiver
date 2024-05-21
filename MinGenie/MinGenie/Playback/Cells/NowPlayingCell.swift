import MusicKit
import SwiftUI

/// ✏️ 현재 재생 화면 정사각형 곡 cell ✏️
///  ✅ 디자인 세부 조정 필요

struct NowPlayingCell: View {
    // MARK: - Constants
    private static let defaultArtworkSize = 250.0
    private static let defaultArtworkCornerRadius = 6.0
    
    // MARK: - Properties선언과 Initialization
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    
      var artwork: Artwork? = nil
      var title: String = "Unknown Title"
      var artist: String = "Unknown Artist"
      var subtitle: String = ""
      var artworkSize: CGFloat = defaultArtworkSize
      var artworkCornerRadius: CGFloat = defaultArtworkCornerRadius
      var subtitleVerticalOffset: CGFloat = 0.0
        
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            VStack {
                if let itemArtwork = artwork {
                    ZStack {
                        imageContainer(for: itemArtwork)
                            .frame(width: artworkSize, height: artworkSize)
                            .shadow(radius: artworkCornerRadius)
                        
                        if let currentItem = playbackQueue.currentEntry?.item {
                            PlayButton(for: currentItem)
                        } else {
                            Text("No Item Playing")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                Text(artist)
                    .font(.title3)
                
                
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .padding(.top, (-2.0 + subtitleVerticalOffset))
                }
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
