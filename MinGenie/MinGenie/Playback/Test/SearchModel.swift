//
//  SearchModel.swift
//  MinGenie
//
//  Created by dora on 5/20/24.
//

/// ❌ 아직 HomeView와 연동하기 전이라 임의로 만들어둔 RequestModel입니다 ❌

import SwiftUI
import MusicKit

/// 요청해서 받아온 정보들을 Item 구조체 모양으로 정리할 겁니다.
struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
    let song: Song
}

class SearchModel: ObservableObject {
    
    /// 요청해서 받아온 노래들을 담아서 Publish
    @Published var songs = [Item]()
    @ObservedObject var musicPlayer = MusicPlayerModel.shared
    
    /// MusicKit - MusicCatalogSearchRequest
    private let request: MusicCatalogSearchRequest = {
        
        /// 실리카겔 검색결과를 Song타입으로 25개 가져왔어요.
        var request = MusicCatalogSearchRequest(term: "Silicagel", types: [Song.self])
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
                                         imageUrl: $0.artwork?.url(width: 75, height: 75),
                                         song: $0.self)
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

