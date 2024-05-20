/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A SwiftUI view that implements a mini music player.
*/

import MusicKit
import SwiftUI

/// A view that implements a music player at the bottom of another view.
struct MiniPlayerView: View {
    
    // MARK: - Properties
    
    @ObservedObject var playbackQueue = ApplicationMusicPlayer.shared.queue
    @ObservedObject private var musicPlayer = MusicPlayer.shared
    @State var isShowingNowPlaying = false
    @State var isShowingMusic = false
    
    // MARK: - View
    
    var body: some View {
        content
            .frame(height: 80)
            .frame(maxWidth: .infinity)
//            .sheet(isPresented: $isShowingNowPlaying) {
//                NowPlayingView(playbackQueue: playbackQueue)
//            }
            .fullScreenCover(isPresented: $isShowingNowPlaying){
                NowPlayingView(playbackQueue: playbackQueue)
            }
        

            
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    //.fill(Color(UIColor.systemBackground))
                    .fill(.blue)
                    .padding([.leading, .trailing])
                    //.standardShadow()
            }
    }
    
    @ViewBuilder // 여러 상태값에 따라 여러 뷰를 반환하고 싶을 때 사용
    private var content: some View {
        if let currentPlayerEntry = playbackQueue.currentEntry {
            HStack {
                Button(action: handleTap) {
                    MusicItemCell2(
                        artwork: currentPlayerEntry.artwork,
                        artworkSize: 64.0,
                        artworkCornerRadius: 12.0,
                        title: currentPlayerEntry.title,
                        subtitle: currentPlayerEntry.subtitle,
                        subtitleVerticalOffset: -4.0
                    )
                    Spacer()
                    HStack{
                        pauseButton
                            .padding()
                    }
                }
                
                //seeQueueView
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
        } else {
            Button(action: handleTap) {
                MusicItemCell2(
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
    
//    var seeQueueView: some View {
//        Button {
//            isShowingNowPlaying = true
//        } label: {
//            Image(systemName: "list.bullet")
//                .font(.system(size: 18))
//                .foregroundColor(.black)
//        }
//    }
    
    // MARK: - Methods
    
    private func pausePlay() {
        musicPlayer.togglePlaybackStatus()
    }
    
    private func handleTap() {
        isShowingMusic = true
        isShowingNowPlaying = true
    }
}



