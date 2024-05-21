import MusicKit
import SwiftUI

/// ✏️ 현재 재생 (full Screen) View입니다 ✏️
///  애플 예제에서 사용할 부분만 추려 온 건데, custom한 부분들 표시해두겠습니다!

struct NowPlayingView: View{
    
    /// queue 상태 받아와서 표시할 것
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    /// miniPlayerView와 전환되기 위한 bool
    @Environment(\.presentationMode) var presentation
    
    var body: some View{
        NavigationView{
            ZStack{
                VStack{
                    HStack{
                        /// ✅ 디자인 세부 조정 필요
                        VStack(alignment: .leading){
                            Text("(애플 id님,)")
                                .font(.title3)
                                .foregroundStyle(.black)
                            Text("못할 것도 없지🔥")
                                .font(.title.bold())
                                .foregroundStyle(.blue)
                        }
                        Spacer()
                    }
                    .padding(.top,30)
                    .padding(.leading,30)
                    
                    NowPlayingCell(playbackQueue: playbackQueue, artwork: playbackQueue.currentEntry?.artwork, title: playbackQueue.currentEntry?.title, artist: playbackQueue.currentEntry?.subtitle )
                    
                }
                
                VStack{
                    /// grabber 버튼 - dismiss 동작 넘겨줌
                    DismissButton { dismiss() }
                    Spacer()
                }
                
                
            }
        }
        .gesture(
            /// fullScreenCover에서 드래그로 dismiss하기 위해선 커스텀이 필요함
            DragGesture().onEnded { value in
                /// 세로로 150 이상 움직이면 dismiss
                if value.translation.height > 150 {
                    dismiss()
                }
            }
        )

    }
    
    
    private func dismiss() {
        presentation.wrappedValue.dismiss()
    }
    
    
    public struct DismissButton: View {
        ///이거 선언할 때, dismiss 동작 받아옴.
        ///버튼을 눌렀을 때 수행할 동작(dismiss)을 담아 초기화
        var action: () -> ()
        
        public init(_ action: @escaping () -> ()) {
            self.action = action
        }
        
        public var body: some View {
            Button(action: action) {
                /// grabber 버튼 그림
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray)
                    .frame(width: 50, height: 5)
                    .padding()
            }
        }
    }
    
    
    /// 👇아래는 미사용중이긴 한데, 재생대기목록 띄우려면 나중에 쓸 거 같아서 남겨둠
    @ViewBuilder
    private var content: some View{
        list(for: playbackQueue)
    }
    
    private func list(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View{
        List{
            ForEach(playbackQueue.entries){ entry in
                PlayerMusicItemCell(
                    artwork: entry.artwork,
                    artworkSize: 44,
                    artworkCornerRadius: 4,
                    title: entry.title,
                    subtitle: entry.subtitle,
                    subtitleVerticalOffset: -2.0
                )
            }
            // 특정 배열의 인덱스가 offset
            .onDelete{ offsets in
                playbackQueue.entries.remove(atOffsets: offsets)
            }
            .onMove{ source, destination in
                playbackQueue.entries.move(fromOffsets: source, toOffset: destination)
            }
            .animation(.default, value: playbackQueue.entries)
            .toolbar {
                EditButton()
            }
        }
    }
}



