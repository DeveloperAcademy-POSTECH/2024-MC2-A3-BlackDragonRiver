import MusicKit
import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerModel
    
    ///FullScreen Dismiss 관련
    @Environment(\.presentationMode) var presentation
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        /// 전체 View 구성
        NavigationView {
            
            VStack(spacing: 0) {
                DismissButton { fullScreenDismiss() }
                    .padding(.bottom, 10)
                HStack {
                    Text("Flowish")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.Text.black)
                        .padding()
                    Spacer()
                }
                
                ZStack {
                    CarouselView
                    pauseButton
                        .padding(.bottom, -20)
                }
                .frame(height: 360)
                
                QueueView
            }
            .background(Color.BG.main)
        }
        
        /// FullScreenDismiss 드래그 감지
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 150 {
                    fullScreenDismiss()
                }
            }
        )
        .onAppear {
            /// onAppear시, entries에서의 index와 캐러셀의 index를 일치시켜줘요!
            if let savedEntryIndex = musicPlayer.playbackQueue.entries.firstIndex(where: { $0.id == musicPlayer.playbackQueue.currentEntry?.id }) {
                musicPlayer.currentMusicIndex = savedEntryIndex
            }
            /// entries에 아무것도 안담겨 있으면 index 0으로 초기화해요!
            else {
                musicPlayer.currentMusicIndex = 0
            }
        }
        /// fullScreen일때, 현재재생곡이 넘어가면 캐러셀이 전환되는 부분입니다!
        .onChange(of: musicPlayer.playbackQueue.currentEntry) { _, entry in
            /// 또 전수검사 해줘요..
            if let entry = entry, let newIndex = musicPlayer.playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) {
                musicPlayer.currentMusicIndex = newIndex
            }
        }
    }
    
    @ViewBuilder
    private var QueueView: some View {
        ZStack {
            Color.BG.main.ignoresSafeArea(.all)
            QueueList(for: musicPlayer.playbackQueue)
        }
    }
    
    @ViewBuilder
    private func QueueList(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
        ScrollViewReader { proxy in
            List {
                ForEach(playbackQueue.entries.indices, id: \.self) { index in
                    NowQueueItemCell(
                        artwork: playbackQueue.entries[index].artwork,
                        title: playbackQueue.entries[index].title,
                        subtitle: playbackQueue.entries[index].subtitle
                    )
                    .listRowBackground(Color.BG.main)
                    .onTapGesture {
                        playbackQueue.currentEntry = playbackQueue.entries[index]
                        musicPlayer.currentMusicIndex = index
                        if !musicPlayer.isPlaying { pausePlay() }
                    }
                }
            }
            .background(Color.BG.main)
            .listStyle(.plain)
            
            ///비활성화되어있을 때 곡이 넘어가도, 켜면 바로 그 곡으로 스크롤되도록!
            .onAppear {
                if let entry = playbackQueue.currentEntry, let newIndex = playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) {
                    musicPlayer.currentMusicIndex = newIndex
                    withAnimation {
                        proxy.scrollTo(musicPlayer.currentMusicIndex, anchor: .top)
                    }
                }
            }
            ///현재재생곡이 넘어가면 list가 스크롤되는 부분입니다!
            .onChange(of: playbackQueue.currentEntry) { _, entry in
                if let entry = entry, let newIndex = playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) {
                    musicPlayer.currentMusicIndex = newIndex
                    withAnimation {
                        proxy.scrollTo(musicPlayer.currentMusicIndex, anchor: .top)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var CarouselView: some View {
        CarouselList(for: musicPlayer.playbackQueue)
    }
    
    @ViewBuilder
     private func CarouselList(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
        
        NavigationStack {
            ZStack {
                Color.BG.main.ignoresSafeArea(.all)
                
                VStack {
                    ZStack {
                        if playbackQueue.entries.count > 0 {
                            let startIndex = max(musicPlayer.currentMusicIndex - 2, 0)
                            let endIndex = min(musicPlayer.currentMusicIndex + 2, playbackQueue.entries.count - 1)
                            
                            if startIndex <= endIndex {
                                ForEach(startIndex...endIndex, id: \.self) { index in
                                    
                                    imageContainer(for: playbackQueue.entries[index].artwork)
                                        .scaleEffect(1.0 - CGFloat(abs(index - musicPlayer.currentMusicIndex)) * 0.1)
                                        .zIndex(1.0 - Double(abs(index - musicPlayer.currentMusicIndex)))
                                        .offset(x: CGFloat(index - musicPlayer.currentMusicIndex) * 50 * (1 - CGFloat(abs(index - musicPlayer.currentMusicIndex)) * 0.1) + dragOffset, y: 0)
                                        .padding(.top, -20)
                                    
                                    if index == musicPlayer.currentMusicIndex {
                                        VStack(spacing: 0) {
                                            Text(playbackQueue.entries[index].title)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color.Text.black)
                                                .padding(.top, 16)
                                                .lineLimit(1)
                                            
                                            Text(playbackQueue.entries[index].subtitle ?? "")
                                                .font(.system(size: 15, weight: .regular))
                                                .foregroundColor(Color.Text.black)
                                                .padding(.top, 8)
                                                .padding(.bottom, 16)
                                                .lineLimit(1)
                                        }
                                        .padding(.top, 300)
                                        
                                        .transition(.opacity)
                                        
                                    }
                                }
                            }
                        }
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
                            musicPlayer.currentMusicIndex = max(0, musicPlayer.currentMusicIndex - 1)
                        }
                    } else if value.translation.width < -threshold {
                        withAnimation {
                            musicPlayer.currentMusicIndex = min(playbackQueue.entries.count - 1, musicPlayer.currentMusicIndex + 1)
                        }
                    }
                    /// 캐러셀 넘기면 currentEntry를 갈아치워요!
                    playbackQueue.currentEntry = playbackQueue.entries[musicPlayer.currentMusicIndex]
                }
        )
    }
    
    @ViewBuilder
    private var pauseButton: some View {
        Button(action: pausePlay) {
            Image(systemName: musicPlayer.isPlaying ? "pause.circle" : "play.circle")
                .font(.system(size: 70, weight: .ultraLight))
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
    }
    
    private func pausePlay() {
        musicPlayer.togglePlaybackStatus()
    }
    
    private func fullScreenDismiss() {
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
            if let artwork = artwork {
                ZStack {
                    ArtworkImage(artwork, width: 244, height: 244)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    Rectangle()
                        .frame(width: 244, height: 244)
                        .cornerRadius(16)
                        .foregroundColor(.black)
                        .opacity(0.2)
                }
            } else {
                Image("FlowishGray")
                    .resizable()
                    .frame(width: 244, height: 244)
                    .cornerRadius(16)
                    .shadow(radius: 4)
            }
        }
    }
}
