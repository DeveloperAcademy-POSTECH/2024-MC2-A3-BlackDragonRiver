import MusicKit
import SwiftUI

struct NowPlayingView: View{
    @Environment(\.presentationMode) var presentation
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    @State private var artist: String = ""
    
    var body: some View{
        NavigationView{ // 이거 안쓰고 싶은디? 이걸 써야 작동하는 이유가 머지
            ZStack{
                
                VStack{
                    HStack{
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
                    
                    // subtitle이 가수명임..
                    NowPlayingCell(playbackQueue: playbackQueue, artwork: playbackQueue.currentEntry?.artwork, title: playbackQueue.currentEntry?.title, artist: playbackQueue.currentEntry?.subtitle )
                    //.navigationTitle("현재 재생중")
                    
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
    
    public struct DismissButton: View {
        var action: () -> ()
        
        public init(_ action: @escaping () -> ()) {
            self.action = action
        }
        
        public var body: some View {
            Button(action: action) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray)
                    .frame(width: 50, height: 5)
                    .padding()
            }
        }
    }
    
    // 아직 미사용
    @ViewBuilder
    private var content: some View{
        list(for: playbackQueue)
    }
    
    // 아직 미사용
    private func list(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View{
        List{
            ForEach(playbackQueue.entries){ entry in
                MusicItemCell(
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



