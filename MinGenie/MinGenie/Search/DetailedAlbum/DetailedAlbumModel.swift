//
//  DetailedAlbumModel.swift
//  MinGenie
//
//  Created by 김유빈 on 5/22/24.
//

import MusicKit
import SwiftUI

class DetailedAlbumModel: ObservableObject {
    @Published var tracks: MusicItemCollection<Track>? = []

    /// Loads tracks asynchronously.
    func loadTracks(album: Album) async throws {
        let detailedAlbum = try await album.with([.tracks])
        await update(tracks: detailedAlbum.tracks)
    }
    
    /// Safely updates `tracks`  properties on the main thread.
    @MainActor
    private func update(tracks: MusicItemCollection<Track>?) {
        withAnimation {
            self.tracks = tracks
        }
    }
}
