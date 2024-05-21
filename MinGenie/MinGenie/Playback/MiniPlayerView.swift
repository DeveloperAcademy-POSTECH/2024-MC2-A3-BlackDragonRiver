import MusicKit
import SwiftUI

/// ✏️ 하단에 띄워 둘 미니플레이어 View입니다 ✏️
///  애플 예제에서 사용할 부분만 추려 온 건데, custom한 부분들 표시해두겠습니다!

struct MiniPlayerView: View {
    
    // MARK: - Properties
    /// Player상태 계속 받아올 것
    @ObservedObject var playbackQueue = ApplicationMusicPlayer.shared.queue
    @ObservedObject private var musicPlayer = MusicPlayerModel.shared
    
    /// fullscreen전환 관련 변수
    @State var isShowingNowPlaying = false
    
    // MARK: - View
    /// 1. 전체 view
    var body: some View {
        content
            /// ✅ 디자인 세부 조정 필요
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .fullScreenCover(isPresented: $isShowingNowPlaying){
                NowPlayingView(playbackQueue: playbackQueue)
            }
    }
    
    ///2. 세부 콘텐츠 이미지 view
    @ViewBuilder
    ///(개념) 서로 다른 상태값에 따라 여러 뷰를 반환하고 싶을 때 사용
    private var content: some View {
        /// currentEntry가 현재재생곡이란 뜻임!
        if let currentPlayerEntry = playbackQueue.currentEntry {
            HStack {
                Button(action: handleTap) {
                    PlayerMusicItemCell(
                        artwork: currentPlayerEntry.artwork,
                        artworkSize: 64.0,
                        artworkCornerRadius: 12.0,
                        title: currentPlayerEntry.title,
                        subtitle: currentPlayerEntry.subtitle,
                        subtitleVerticalOffset: -4.0
                    )
                    Spacer()
                    /// ✅ 디자인 세부 조정 필요
                    HStack{
                        pauseButton
                            .padding()
                    }
                }.background {
                    /// ✅ 디자인 세부 조정 필요
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.blue)
                        .padding([.leading, .trailing])
                }
                /// 나중에 쓰게 될 듯하여 남겨둠
                //seeQueueView
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
        } else {
            Button(action: handleTap) {
                /// 현재 재생중인 곡이 없으면 표시할 그림
                PlayerMusicItemCell(
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
    
    /// playback
    private func pausePlay() {
        musicPlayer.togglePlaybackStatus()
    }
    
    /// MiniPlayer Tap하면  fullScreen(NowPlayingView)으로 넘어가기 위한 bool들 true 시켜주는 함수
    private func handleTap() {
        isShowingNowPlaying = true
    }
}



