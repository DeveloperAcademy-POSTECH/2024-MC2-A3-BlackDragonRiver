import MusicKit
import SwiftUI

/// ✏️ 재생 버튼 View입니다 ✏️
///  애플 예제에서 사용할 부분만 추려 온 건데, custom한 부분들 표시해두겠습니다!

struct PlayButton<MusicItemType: PlayableMusicItem>: View {
    
    // MARK: - Initialization
    
    init(for item: MusicItemType) {
        self.item = item
    }
    
    // MARK: - Properties
    
    /// musicPlayer PlayStatus 상태 계속해서 받아와서 표시할 것! (재생 중인지, 멈춰있는지)
    private var item: MusicItemType
    @ObservedObject private var musicPlayer = MusicPlayerModel.shared
    
    // MARK: - View
    
    var body: some View {
        
        /// 버튼 누를 때 재생상태 toggle
        Button(action: { musicPlayer.togglePlaybackStatus(for: item) }) {
            ZStack {
                Image(systemName: (musicPlayer.isPlaying ? "pause.fill" : "play.fill"))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                /// ✅ 사이즈 세부 조정 필요
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 100, height: 100)
            }.shadow(radius: 5)
            
        }
        .buttonStyle(.playStyle)    /// extension으로 넣어줌!
        .animation(.easeInOut(duration: 0.1), value: musicPlayer.isPlaying)
    }

}
