import MusicKit
import SwiftUI

/// ✏️ 현재 재생 (full Screen) View입니다 (정리중)✏️

struct NowPlayingView: View {
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    @ObservedObject private var musicPlayer = MusicPlayerModel.shared
    
    @Environment(\.presentationMode) var presentation
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    /// 1. title
                    VStack(alignment: .leading) {
                        Text("못할 것도 없지🔥")
                            .font(.title.bold())
                            .foregroundStyle(.blue)
                    }
                    .padding(.leading, -150)
                    .padding(.top, 50)
                    .padding(.bottom,-20)
                    
                    /// 2. carousel
                    VStack {
                        if let currentEntry = playbackQueue.currentEntry {
                            VStack {
                                ZStack {
                                    CarouselView
                                    pauseButton
                                        .padding(.bottom, -30)
                                }
                                Text(currentEntry.title)
                                    .font(.system(size: 20, weight: .semibold))
                                Text(currentEntry.subtitle!)
                                    .font(.system(size: 15, weight: .regular))
                            }
                        } else {
                            ZStack {
                                Rectangle()
                                    .frame(width: 264, height: 264)
                                    .cornerRadius(16)
                                    .foregroundColor(.gray)
                                
                                Text("No Item Playing")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    VStack {
                        Queuelist(for: playbackQueue)
                    }
                }
                
                VStack {
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
    private var QueueView: some View {
        Queuelist(for: playbackQueue)
    }
    
    private func Queuelist(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
        ScrollViewReader { proxy in
            List {
                ForEach(playbackQueue.entries) { entry in
                    NowQueueItemCell(
                        artwork: entry.artwork,
                        title: entry.title,
                        subtitle: entry.subtitle
                    ).onTapGesture {
                        playbackQueue.currentEntry = entry
                        
                        /// 현재 재생 index가 queueList 상에서 가장 상단에 붙도록 currentIndex 찾기
                        currentIndex = playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) ?? 0
                        if !musicPlayer.isPlaying { pausePlay() }
                    }
                }
            }
            .listStyle(.plain)
            /// currentIndex가 바뀌면 newIndex로!
            .onChange(of: currentIndex) { newIndex in
                withAnimation {
                    proxy.scrollTo(playbackQueue.entries[newIndex].id, anchor: .top)
                }
            }
            
        }
    }
    
    @ViewBuilder
    private var CarouselView: some View {
        Carousellist(for: playbackQueue)
    }
    
    private func Carousellist(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(playbackQueue.entries.indices, id: \.self) { index in
                        imageContainer(for: playbackQueue.entries[index].artwork)
                            .frame(width: 250, height: 250)
                            .cornerRadius(16)
                            .scaleEffect(1.0 - CGFloat(abs(index - currentIndex)) * 0.1)
                            .zIndex(1.0 - Double(abs(index - currentIndex)))
                            .offset(x: CGFloat(index - currentIndex) * 50 * (1 - CGFloat(abs(index - currentIndex)) * 0.1) + dragOffset, y: 0)
                        
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold {
                        withAnimation {
                            currentIndex = max(0, currentIndex - 1)
                        }
                    } else if value.translation.width < -threshold {
                        withAnimation {
                            currentIndex = min(playbackQueue.entries.count - 1, currentIndex + 1)
                        }
                    }
                    playbackQueue.currentEntry = playbackQueue.entries[currentIndex]
                }
        )
        .padding(.top, 40)
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
    
    private func imageContainer(for artwork: Artwork?) -> some View {
        VStack {
            Spacer()
            if let artwork = artwork {
                ArtworkImage(artwork, width: 250, height: 250)
                    .cornerRadius(8)
                    .shadow(radius: 10)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 250, height: 250)
                    .cornerRadius(8)
                    .shadow(radius: 10)
            }
            Spacer()
        }
    }
}
