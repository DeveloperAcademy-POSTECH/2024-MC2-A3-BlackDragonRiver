//
//  MusicSearchModel.swift
//  MinGenie
//
//  Created by 김유빈 on 5/20/24.
//

import MusicKit
import SwiftUI

enum Category: String {
    case album = "앨범"
    case song = "노래"
}

class MusicSearchModel: ObservableObject {
    @Published var albums: MusicItemCollection<Album> = []
    @Published var songs: MusicItemCollection<Song> = []

    func requestUpdatedSearchResults(for searchTerm: String) {
        Task {
            if searchTerm.isEmpty {
                await self.reset()
            } else {
                do {
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self, Song.self])
                    searchRequest.limit = 25
                    
                    let searchResponse = try await searchRequest.response()
                    
                    print("🙌🏻 응답 :: \(searchResponse)")
                    
                    await self.apply(searchResponse, for: searchTerm)
                } catch {
                    print("Search request failed with error: \(error).")
                    await self.reset()
                }
            }
        }
    }
    
    /// Safely updates the `albums` property on the main thread.
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
            self.albums = searchResponse.albums
            self.songs = searchResponse.songs
    }
    
    /// Safely resets the `albums` property on the main thread.
    @MainActor
    private func reset() {
        self.albums = []
        self.songs = []
    }
}
