import MusicKit
import SwiftUI

struct CarouselView: View {
    @ObservedObject var model = MusicPersonalRecommendationModel()
    @ObservedObject var musicPlayer = MusicPlayerModel.shared
    @ObservedObject var playbackQueue = ApplicationMusicPlayer.Queue()
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    private var artworkSize: CGFloat = 44
    private var artworkCornerRadius: CGFloat = 4

    var body: some View {
        Test_PlaylistView()
        NavigationStack {
            VStack {
                ZStack {
                    if let tracks = model.tracks {
                        ForEach(0..<tracks.count, id: \.self) { index in
                           
                            TrackRow2(track: tracks[index])
                                .frame(width: 250, height: 250)
                                .opacity(1.0 - Double(abs(index - currentIndex)) * 0.2)
                                .cornerRadius(16)
                                .scaleEffect(1.0 - CGFloat(abs(index - currentIndex)) * 0.1)
                                .zIndex(1.0 - Double(abs(index - currentIndex)) * 0.1)
                                .offset(x: CGFloat(index - currentIndex) * 50 * (1 - CGFloat(abs(index - currentIndex)) * 0.1) + dragOffset, y: 0)
                            
                        }
                    }
                    VStack{
                        if let currentItem = playbackQueue.currentEntry?.item {
                            //layButton(for: currentItem)
                            //.padding(.top, 95)
                            Circle()
                                .onTapGesture {
                                    musicPlayer.skipToNextEntry()
                                }
                        }
                        Spacer()
                    }
                }
                .gesture(
                    DragGesture()
                        .updating($dragOffset, body: { value, state, _ in
                            state = value.translation.width
                        })
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                withAnimation {
                                    currentIndex = max(0, currentIndex - 1)
                                    musicPlayer.skipToNextEntry()
                                }
                                
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    currentIndex = min((model.tracks?.count ?? 1) - 1, currentIndex + 1)
                                    musicPlayer.skipToNextEntry()
                                }
                            }
                        }
                )
                .padding(.top, 40)
            }
        }
    }
    
    private var pauseButton: some View {
        Button(action: pausePlay) {
            Image(systemName: (musicPlayer.isPlaying ? "pause.circle" : "play.circle"))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Methods
    
    private func pausePlay() {
        musicPlayer.togglePlaybackStatus()
    }
    
}

struct TrackRow2: View {
    let track: Track

    var body: some View {
        VStack {

                if let artwork = track.artwork {
                    ArtworkView2(artwork: artwork)
                }
                VStack(alignment: .leading) {
                    Text(track.title)
                        .font(.system(size: 17))
                    Text(track.artistName)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .lineLimit(1)
            
            
        }
//        .padding(.horizontal, 16)
//        .frame(height: 62) // 고정 높이 설정
        
    }
}

struct ArtworkView2: View { // 'ArtworkView2'에서 'ArtworkView'로 변경
    let artwork: Artwork

    var body: some View {
        if let url = artwork.url(width: 50, height: 50) {
            AsyncImage(url: url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                Color.gray.opacity(0.3)
            }
        } else {
            Color.gray.opacity(0.3)
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}


