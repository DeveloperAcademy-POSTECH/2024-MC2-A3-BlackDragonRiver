import MusicKit
import SwiftUI

/// ✏️ 현재 재생 View입니다 (수정중) ✏️

struct NowPlayingView: View {
    
    ///Music Player관련
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    @ObservedObject private var musicPlayer = MusicPlayerModel.shared
    
    ///FullScreen Dismiss 관련
    @Environment(\.presentationMode) var presentation
    @GestureState private var dragOffset: CGFloat = 0
    
    ///Carousel 인덱스 관련
    @AppStorage("currentIndex") private var currentIndex: Int = 0

    var body: some View {
        /// 전체 View 구성
        NavigationView {
            ZStack {
                Color.BG.main.ignoresSafeArea(.all)
                VStack {
                    ZStack {
                        CarouselView
                            .padding(.top, 20)
                        pauseButton
                            .padding(.bottom, -28)
                    }
                    .frame(height: 420)
                    VStack {
                        QueueView
                    }
                }
                VStack {
                    Text("못할 것도 없지 화이팅🔥")
                        .font(.system(size: 34, weight: .black))
                        .foregroundStyle(Color.Text.blue)
                }
                .padding(.leading, -18)
                .padding(.top, -345)
                VStack {
                    DismissButton { FullScreenDismiss() }
                    Spacer()
                }
            }
        }
        /// FullScreenDismiss 드래그 감지
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 150 {
                    FullScreenDismiss()
                }
            }
        )
        .onAppear {
            /// onAppear시, entries에서의 index와 캐러셀의 index를 일치시켜줘요!
            if let savedEntryIndex = playbackQueue.entries.firstIndex(where: { $0.id == playbackQueue.currentEntry?.id }) {
                currentIndex = savedEntryIndex
            } 
            /// entries에 아무것도 안담겨 있으면 index 0으로 초기화해요!
            else {
                currentIndex = 0
            }
        }
        /// fullScreen일때, 현재재생곡이 넘어가면 캐러셀이 전환되는 부분입니다!
        .onChange(of: playbackQueue.currentEntry) { entry in
            /// 또 전수검사 해줘요..
            if let entry = entry, let newIndex = playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) {
                currentIndex = newIndex
            }
        }
        
    }

    @ViewBuilder
    private var QueueView: some View {
        ZStack {
            Color.BG.main.ignoresSafeArea(.all)
            Queuelist(for: playbackQueue)
        }
    }
    @ViewBuilder
    private func Queuelist(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
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
                        currentIndex = index
                        if !musicPlayer.isPlaying { pausePlay() }
                    }
                }
            }
            .background(Color.BG.main)
            .listStyle(.plain)
            ///비활성화되어있을 때 곡이 넘어가도, 켜면 바로 그 곡으로 스크롤되도록!
            .onAppear {
                if let entry = playbackQueue.currentEntry, let newIndex = playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) {
                    currentIndex = newIndex
                    withAnimation {
                        proxy.scrollTo(currentIndex, anchor: .top)
                    }
                }
            }
            ///현재재생곡이 넘어가면 list가 스크롤되는 부분입니다!
            .onChange(of: playbackQueue.currentEntry) { entry in
                if let entry = entry, let newIndex = playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) {
                    currentIndex = newIndex
                    withAnimation {
                        proxy.scrollTo(currentIndex, anchor: .top)
                    }
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
            ZStack {
                Color.BG.main.ignoresSafeArea(.all)
                
                VStack {
                    ZStack {
                        ForEach(max(currentIndex - 2, 0)...min(currentIndex + 2, playbackQueue.entries.count - 1), id: \.self) { index in
                            imageContainer(for: playbackQueue.entries[index].artwork)
                                .scaleEffect(1.0 - CGFloat(abs(index - currentIndex)) * 0.1)
                                .zIndex(1.0 - Double(abs(index - currentIndex)))
                                .offset(x: CGFloat(index - currentIndex) * 50 * (1 - CGFloat(abs(index - currentIndex)) * 0.1) + dragOffset, y: 0)
                            
                            if index == currentIndex {
                                VStack {
                                    Text(playbackQueue.entries[index].title)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.Text.black)
                                        .padding(.top, 16)
                                    
                                    Text(playbackQueue.entries[index].subtitle ?? "")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color.Text.black)
                                        .padding(.top, -10)
                                }
                                .padding(.top, 310)
                                .transition(.opacity)
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
                            currentIndex = max(0, currentIndex - 1)
                        }
                    } else if value.translation.width < -threshold {
                        withAnimation {
                            currentIndex = min(playbackQueue.entries.count - 1, currentIndex + 1)
                        }
                    }
                    /// 캐러셀 넘기면 currentEntry를 갈아치워요!
                    playbackQueue.currentEntry = playbackQueue.entries[currentIndex]
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
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 244, height: 244)
                    .cornerRadius(16)
                    .shadow(radius: 4)
            }
            Spacer()
        }
    }
}
