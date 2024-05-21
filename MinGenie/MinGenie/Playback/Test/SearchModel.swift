//
//  SearchModel.swift
//  MinGenie
//
//  Created by dora on 5/20/24.
//

/// ❌ 아직 HomeView와 연동하기 전이라 임의로 만들어둔 RequestModel입니다 ❌
import MusicKit
import SwiftUI

class MusicPersonalRecommendationModel: ObservableObject {
    private var personalRecommendations: MusicItemCollection<MusicPersonalRecommendation> = []
    @Published var tracks: MusicItemCollection<Track> = []
    @Published var playlist: Playlist?
    
    
    init() {
        self.requestMusicPersonalRecommendation()
    }
    
    private func requestMusicPersonalRecommendation() {
        Task {
            do {
                let request = MusicPersonalRecommendationsRequest()
                let response = try await request.response()
                await self.findPlaylist(response)
                try? await loadTracks()
                
            } catch {
                print("Personal recommendation request failed with error: \(error)")
            }
        }
    }
    
    /// Loads tracks asynchronously.
    private func loadTracks() async throws {
        guard let playlist = self.playlist else {
            print("🚫 Playlist Problem")
            return
        }
        
        let detailedAlbum = try await playlist.with([.tracks])
        
        guard let tracks = detailedAlbum.tracks else {
            print("🚫 Tracks Problem")
            return
        }
        await update(tracks: tracks)
    }
    
    private func findPlaylist(_ response: MusicPersonalRecommendationsResponse) async {
        self.personalRecommendations = response.recommendations
        for recommendation in self.personalRecommendations {
            if !recommendation.playlists.isEmpty {
                self.playlist = recommendation.playlists.first
                break
            }
        }
    }
    
    @MainActor
    private func update(tracks: MusicItemCollection<Track>) {
            self.tracks = tracks
    }
}



/// 요청해서 받아온 정보들을 Item 구조체 모양으로 정리할 겁니다.
struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
}

class SearchModel: ObservableObject {
    
    /// 요청해서 받아온 노래들을 담아서 Publish
    @Published var songs = [Item]()
    @ObservedObject var musicPlayer = MusicPlayerModel.shared
    
    /// MusicKit - MusicCatalogSearchRequest
    private let request: MusicCatalogSearchRequest = {
        
        /// 실리카겔 검색결과를 Song타입으로 25개 가져왔어요.
        var request = MusicCatalogSearchRequest(term: "Silicagel", types: [Song.self])
        //var request = MusicCatalogSearchRequest(term: "Silicagel", types: [Playlist.self])
        request.limit = 25
        
        return request
        
    }()
    
    /// SearchModel Class가 생성될 때, 바로 요청을 받아올 거예요.
    init() {
        fetchMusic()
    }
    
    private func fetchMusic() {
        Task {
            /// 애플 뮤직 권한을 요청하고 받아옵니다.
            let status = await MusicAuthorization.request()
            
            
            switch status {
            case .authorized:
                /// 권한을 인정 받으면, Item 구조체 모양으로 song들을 배열에 담아줄 거고요.
                do {
                    let result = try await request.response()
                    DispatchQueue.main.async {
                        self.songs = result.songs.compactMap({
                            return .init(name: $0.title,
                                         artist: $0.artistName,
                                         imageUrl: $0.artwork?.url(width: 75, height: 75))
                        })
                    }
                /// 거절되면, 에러 메세지를 띄워 줄게요!
                } catch {
                    print(String(describing: error))
                }
            /// default case로 넘어올 일은 거의 없겠죠?
            default:
                break
            }
        }
    }
}

