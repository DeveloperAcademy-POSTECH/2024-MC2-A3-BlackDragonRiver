import MusicKit
import SwiftUI

/// ✏️ 하단에 띄워 둘 미니플레이어 View입니다 ✏️

struct MiniPlayerView: View {
    
    // MARK: - Properties
    @ObservedObject var playbackQueue = ApplicationMusicPlayer.shared.queue
    @ObservedObject private var musicPlayer = MusicPlayerModel.shared
    
    /// fullscreen전환 관련 변수
    @State var isShowingNowPlaying = false
    
    // MARK: - View
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.blue)
                    .frame(height: 60)
                    .padding(.horizontal,24)
            )
            .fullScreenCover(isPresented: $isShowingNowPlaying) {
                NowPlayingView(playbackQueue: playbackQueue)
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if let currentPlayerEntry = playbackQueue.currentEntry {
            HStack {
                VStack(alignment: .leading){
                    Button(action: handleTap) {
                        MiniPlayerItemCell(
                            artwork: currentPlayerEntry.artwork,
                            title: currentPlayerEntry.title,
                            subtitle: currentPlayerEntry.subtitle
                        )
                        Spacer()
                    }
                    .padding(.horizontal,8)
                }
                
                VStack(alignment: .trailing){
                    pauseButton
                        .padding(.horizontal,12)
                }
                
            }
            .padding(.horizontal, 24)
        } else {
            HStack {
                VStack(alignment: .leading){
                    Button(action: handleTap) {
                        MiniPlayerItemCell(
                            artwork: nil,
                            title: "Nothing Playing",
                            subtitle: "노래를 골라주세요!")
                        Spacer()
                    }
                    .padding(.horizontal,8)
                }
                
                VStack(alignment: .trailing){
                    pauseButton
                        .padding(.horizontal,12)
                }
                
            }
            .padding(.horizontal, 24)
        }
        
    }
    
    var pauseButton: some View {
        Button(action: pausePlay) {
            Image(systemName: (musicPlayer.isPlaying ? "pause.fill" : "play.fill"))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Methods
    
    private func pausePlay() {
        musicPlayer.togglePlaybackStatus()
    }
    
    private func handleTap() {
        isShowingNowPlaying = true
    }
}



