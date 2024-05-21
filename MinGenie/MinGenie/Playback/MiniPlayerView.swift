import MusicKit
import SwiftUI

/// ✏️ 하단에 띄워 둘 미니플레이어 View입니다 ✏️
///  애플 예제에서 사용할 부분만 추려 온 건데, custom한 부분들 표시해두겠습니다!

struct MiniPlayerView: View {
    
    // MARK: - Properties
    
    @ObservedObject var playbackQueue = ApplicationMusicPlayer.shared.queue
    @ObservedObject private var musicPlayer = MusicPlayerModel.shared
    @State var isShowingNowPlaying = false
    @State var isShowingMusic = false
    
    // MARK: - View
    
    var body: some View {
        content
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .fullScreenCover(isPresented: $isShowingNowPlaying){
                NowPlayingView(playbackQueue: playbackQueue)
            }
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.blue)
                    .padding([.leading, .trailing])
            }
    }
    
    @ViewBuilder // 여러 상태값에 따라 여러 뷰를 반환하고 싶을 때 사용
    private var content: some View {
        if let currentPlayerEntry = playbackQueue.currentEntry {
            HStack {
                Button(action: handleTap) {
                    MusicItemCell2(
                        artwork: currentPlayerEntry.artwork,
                        artworkSize: 64.0,
                        artworkCornerRadius: 12.0,
                        title: currentPlayerEntry.title,
                        subtitle: currentPlayerEntry.subtitle,
                        subtitleVerticalOffset: -4.0
                    )
                    Spacer()
                    HStack{
                        pauseButton
                            .padding()
                    }
                }
                
                //seeQueueView
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
        } else {
            Button(action: handleTap) {
                MusicItemCell2(
                    artwork: nil,
                    artworkSize: 64.0,
                    artworkCornerRadius: 12.0,
                    title: "Nothing Playing",
                    subtitle: "Click here to explore music content",
                    subtitleVerticalOffset: -4.0
                )
            }
        }
    }
    
    var pauseButton: some View {
        Button(action: pausePlay) {
            Image(systemName: (musicPlayer.isPlaying ? "pause.fill" : "play.fill"))
                .foregroundColor(.black)
        }
    }
    
    // MARK: - Methods
    
    private func pausePlay() {
        musicPlayer.togglePlaybackStatus()
    }
    
    /// MiniPlayer Tap하면  fullScreen(NowPlayingView)으로 넘어가기 위한 bool들 true 시켜주는 함수
    private func handleTap() {
        isShowingMusic = true
        isShowingNowPlaying = true
    }
}



