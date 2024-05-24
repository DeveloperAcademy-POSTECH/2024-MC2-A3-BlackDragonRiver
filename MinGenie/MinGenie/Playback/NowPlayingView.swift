import MusicKit
import SwiftUI

struct NowPlayingView: View {
    @ObservedObject var playbackQueue: ApplicationMusicPlayer.Queue
    @EnvironmentObject var musicPlayerModel: MusicPlayerModel
    
    @Environment(\.presentationMode) var presentation

    @AppStorage("currentIndex") private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
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
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 150 {
                    FullScreenDismiss()
                }
            }
        )
        .onChange(of: playbackQueue.currentEntry) { _, entry in
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

    private func Queuelist(for playbackQueue: ApplicationMusicPlayer.Queue) -> some View {
        ScrollViewReader { proxy in
            List {
                ForEach(playbackQueue.entries) { entry in
                    NowQueueItemCell(
                        artwork: entry.artwork,
                        title: entry.title,
                        subtitle: entry.subtitle
                    )
                    .listRowBackground(Color.BG.main)
                    .onTapGesture {
                        playbackQueue.currentEntry = entry
                        currentIndex = playbackQueue.entries.firstIndex(where: { $0.id == entry.id }) ?? 0
                        if !musicPlayerModel.isPlaying { pausePlay() }
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.BG.main)
            .onChange(of: currentIndex) { _, newIndex in
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
                    playbackQueue.currentEntry = playbackQueue.entries[currentIndex]
                }
        )
    }

    @ViewBuilder
    private var pauseButton: some View {
        Button(action: pausePlay) {
            Image(systemName: musicPlayerModel.isPlaying ? "pause.circle" : "play.circle")
                .font(.system(size: 70, weight: .ultraLight))
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
    }

    private func pausePlay() {
        musicPlayerModel.togglePlaybackStatus()
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
