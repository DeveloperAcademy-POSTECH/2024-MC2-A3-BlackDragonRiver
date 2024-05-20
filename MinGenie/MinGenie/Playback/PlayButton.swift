/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A SwiftUI view that implements the play button.
*/

import MusicKit
import SwiftUI

/// A view that toggles playback for a given music item.
struct PlayButton<MusicItemType: PlayableMusicItem>: View {
    
    // MARK: - Initialization
    
    init(for item: MusicItemType) {
        self.item = item
    }
    
    // MARK: - Properties
    
    private var item: MusicItemType
    @ObservedObject private var musicPlayer = MusicPlayer.shared
    
    /// The localized label for the button when it's in the "Play" state.
    private let playButtonTitle: LocalizedStringKey = "Play"
    
    /// The localized label for the button when it's in the "Pause" state.
    private let pauseButtonTitle: LocalizedStringKey = "Pause"
    
    // MARK: - View
    
    var body: some View {
        Button(action: { musicPlayer.togglePlaybackStatus(for: item) }) {
            ZStack {
                Image(systemName: (musicPlayer.isPlaying ? "pause.fill" : "play.fill"))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    
                Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 100, height: 100)
            }.shadow(radius: 5)
            
        }
        .buttonStyle(.playStyle)// extension으로 넣어준 거임
        .animation(.easeInOut(duration: 0.1), value: musicPlayer.isPlaying)
    }
    
    private var symbolName: String {
        return (musicPlayer.isPlaying ? "pause.fill" : "play.fill")
    }
    
    private var title: LocalizedStringKey {
        return (musicPlayer.isPlaying ? pauseButtonTitle : playButtonTitle)
    }
    
}
