import MusicKit
import SwiftUI

/// ✏️ 현재 재생 (full Screen) View입니다 ✏️

struct NowPlayingView: View {
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    @ObservedObject private var musicPlayer = MusicPlayerModel.shared
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
                                //CarouselView()
                                
                                pauseButton
                                    .padding(.bottom,50)
                                
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
                    
                    VStack{
                        QueueView
                    }
                }
                
                VStack{
                    DismissButton { FullScreenDismiss() }
                    Spacer()
                }
            }
        }
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 150 {
                    FullScreenDismiss()
                }
            }
        )
        
    }
    
    @ViewBuilder
    private var QueueView: some View{
        list(for: playbackQueue)
    }
    
    private func list(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
        
        List{
            
            ForEach(playbackQueue.entries, id: \.id) { entry in
                
                NowQueueItemCell(
                    artwork: entry.artwork,
                    title: entry.title,
                    subtitle: entry.subtitle
                ).onTapGesture {
                    playbackQueue.currentEntry = entry
                }
            }
        }
    }
    
    
    @ViewBuilder
    private var pauseButton: some View {
        Button(action: pausePlay) {
            Image(systemName: (musicPlayer.isPlaying ? "pause.circle" : "play.circle"))
                .font(.system(size: 70, weight: .ultraLight))
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
    }
    
    // MARK: - Methods
    
    private func pausePlay() {
        musicPlayer.togglePlaybackStatus()
    }
    
    
    private func FullScreenDismiss() {
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
    
}



