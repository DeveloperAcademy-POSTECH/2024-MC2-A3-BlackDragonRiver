import MusicKit
import SwiftUI

/// ✏️ 현재 재생 (full Screen) View입니다 ✏️

struct NowPlayingView: View {
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    @Environment(\.presentationMode) var presentation
    
    var body: some View{
        NavigationView{
            ZStack{
                VStack{
                    /// 1. title
                    VStack(alignment: .leading){
                        Text("못할 것도 없지🔥")
                            .font(.title.bold())
                            .foregroundStyle(.blue)
                    }
                    .padding(.leading, -150)
                    .padding(.top, 50)
                    
                    /// 2. carousel
                    VStack{
                        if let currentEntry = playbackQueue.currentEntry {
                            ZStack{
                                NowPlayingItemCell(artwork: playbackQueue.currentEntry?.artwork, title: playbackQueue.currentEntry?.title,
                                                   subtitle: playbackQueue.currentEntry?.subtitle)
                                VStack{
                                    if let currentItem = playbackQueue.currentEntry?.item {
                                        PlayButton(for: currentItem)
                                            .padding(.top, 95)
                                    }
                                    Spacer()
                                }
                            }
                        } else {
                            ZStack{
                                Rectangle()
                                    .frame(width: 264, height: 264)
                                    .cornerRadius(16)
                                    .foregroundColor(.gray)
                                    
                                Text("No Item Playing")
                                    .foregroundColor(.black)
                            }
                            
                        }
                    }
                    
                    /// 3. list 나중에 채울 예정
                    VStack{
//                        TrackListView()
                    }
                }
                
                VStack{
                    DismissButton { dismiss() }
                    Spacer()
                }
            }
        }
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 150 {
                    dismiss()
                }
            }
        )
        
    }
    
    
    private func dismiss() {
        presentation.wrappedValue.dismiss()
    }
    
    private struct DismissButton: View {
        var action: () -> ()
        
        init(_ action: @escaping () -> ()) {
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
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
    
    private func list(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
        List{
            ForEach(playbackQueue.entries){ entry in
                NowPlayingItemCell(
                    artwork: entry.artwork,
                    title: entry.title,
                    subtitle: entry.subtitle
                )
            }
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



