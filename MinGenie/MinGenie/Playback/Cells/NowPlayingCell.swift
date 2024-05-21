import MusicKit
import SwiftUI

/// ✏️ 현재 재생 화면 정사각형 곡 cell ✏️
///  ✅ 디자인 세부 조정 필요

struct NowPlayingCell: View {
    
    // MARK: - Initialization
    
    init(
        playbackQueue: ApplicationMusicPlayer.Queue,
        artwork: Artwork? = nil,
        artworkSize: CGFloat = Self.defaultArtworkSize,
        artworkCornerRadius: CGFloat = Self.defaultArtworkCornerRadius,
        title: String? = nil,
        subtitle: String? = nil,
        subtitleVerticalOffset: CGFloat = 0.0,
        artist: String? = nil
    ) {
        self.playbackQueue = playbackQueue
        self.artwork = artwork
        self.artworkSize = artworkSize
        self.artworkCornerRadius = artworkCornerRadius
        self.title = (title ?? "")
        self.subtitle = (subtitle ?? "")
        self.subtitleVerticalOffset = subtitleVerticalOffset
        self.artist = (artist ?? "")
    }
    
    // MARK: - Properties
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    
    let artwork: Artwork?
    let artworkSize: CGFloat
    let artworkCornerRadius: CGFloat
    let title: String
    let subtitle: String
    let subtitleVerticalOffset: CGFloat
    let artist: String
    
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
    
    // MARK: - Constants
    private static let defaultArtworkSize = 250.0
    private static let defaultArtworkCornerRadius = 6.0
}
