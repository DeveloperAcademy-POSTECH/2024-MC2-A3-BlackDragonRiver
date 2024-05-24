import MusicKit
import SwiftUI

/// ✏️ 하단에 띄워 둘 미니플레이어 View입니다 (완성) ✏️

struct MiniPlayerView: View {
    
    // MARK: - Properties
    @ObservedObject private var playbackQueue = ApplicationMusicPlayer.shared.queue
    @EnvironmentObject var musicPlayerModel: MusicPlayerModel
    
    /// fullscreen전환 관련 변수
    @State private var isShowingNowPlaying = false
    
    
    // MARK: - View
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.Shape.blue)
                    .frame(height: 60)
                    .padding(.horizontal,24)
                    .shadow(radius: 20)
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
                    
                }
                
                VStack(alignment: .trailing){
                    pauseButton
                        .padding(.horizontal, 20)
                }
                
            }
            .padding(.horizontal, 24)
        } else {
            HStack {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.secondary)
                            .cornerRadius(4)
                        
                        Image(systemName: "music.note")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    
                    Text("현재 재생 중인 곡이 없습니다.")
                        .lineLimit(1)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color.Text.white100)
                        .padding(.horizontal, -6)
                }
                
                Spacer()
                VStack(alignment: .trailing){
                    pauseButton
                        .padding(.horizontal, 20)
                }.hidden()
            }
            .padding(.horizontal, 24)
        }
    }
    @ViewBuilder
    private var pauseButton: some View {
        Button(action: pausePlay) {
            Image(systemName: (musicPlayer.isPlaying ? "pause.fill" : "play.fill"))
                .foregroundColor(Color.Text.white100)
        }
    }
    
    // MARK: - Methods
    
    private func pausePlay() {
        musicPlayerModel.togglePlaybackStatus()
    }
    
    private func handleTap() {
        isShowingNowPlaying = true
    }
}



