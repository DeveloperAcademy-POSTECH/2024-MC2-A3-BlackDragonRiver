//
//  ContentView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/13/24.
//

import MusicKit
import SwiftUI

struct ContentView: View {
    @State private var searchTerm = ""
    @State private var albums: MusicItemCollection<Album> = []
        
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            AuthView(musicAuthorizationStatus: .constant(.notDetermined))
            
            Button {
                requestUpdatedSearchResults(for: "day6")
            } label: {
                Text("load")
            }
        }
        .padding()
    }
    
    /// Makes a new search request to MusicKit when the current search term changes.
    private func requestUpdatedSearchResults(for searchTerm: String) {
        Task {
            if searchTerm.isEmpty {
                await self.reset()
            } else {
                do {
                    // Issue a catalog search request for albums matching the search term.
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
                    searchRequest.limit = 5
                    print("👍 \(searchRequest)")
                    
                    let searchResponse = try await searchRequest.response()
                    
                    print("🙌🏻 \(searchResponse)")
                    // Update the user interface with the search response.
                    await self.apply(searchResponse, for: searchTerm)
                } catch {
                    print("Search request failed with error: \(error).")
                    await self.reset()
                }
            }
        }
    }
    
    /// Safely resets the `albums` property on the main thread.
    @MainActor
    private func reset() {
        self.albums = []
        print("reset")
    }
    
    /// Safely updates the `albums` property on the main thread.
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.albums = searchResponse.albums
            print(albums)
        }
    }
}

#Preview {
    ContentView()
}
