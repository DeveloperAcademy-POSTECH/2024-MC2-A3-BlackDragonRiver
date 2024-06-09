import Combine
import MusicKit
import SwiftUI

/// ✏️ 재생기 기능을 하는 MusicPlayerModel 스크립트입니다 ✏️
///
/// (개념 정리) Combine 비동기처리
/// Publisher: 값이나 이벤트를 생성하고 방출하는 역할
/// Subscriber: Publisher로부터 방출된 값을 수신하여 처리하는 역할
/// Data Stream: Publisher에서 Subscriber까지 이어지는 데이터의 흐름
/// Combine = 이 데이터 스트림 과정에서 비동기 이벤트를 효율적으로 처리하는 것!

/// 대략적인 과정 : MusicPlayerModel의 play 함수 실행 ➡️ MusicKit의 MusicPlayer(본체)의 queue에 해당 곡 담은 후 재생

class MusicPlayerModel: ObservableObject {
    static let shared = MusicPlayerModel()
    
    private init() {}
    
    // MARK: - Properties
    @Published var isPlaying = false
    @Published var playbackQueue = ApplicationMusicPlayer.shared.queue
    
    
    
    var playbackStateObserver: AnyCancellable?
    
    /// Return : Queue가 셋팅된 ApplicationMusicPlayer
    private var musicPlayer: ApplicationMusicPlayer {
        let musicPlayer = ApplicationMusicPlayer.shared
        if playbackStateObserver == nil {
            playbackStateObserver = musicPlayer.state.objectWillChange
                .sink { [weak self] in
                    self?.handlePlaybackStateDidChange()
                }
        }
        return musicPlayer
    }
    
    private var isPlaybackQueueInitialized = false
    private var playbackQueueInitializationItemID: MusicItemID?
    
    // MARK: - Methods
    
    func togglePlaybackStatus<MusicItemType: PlayableMusicItem>(for item: MusicItemType) {
        if !isPlaying {
            
            let isPlaybackQueueInitializedForSpecifiedItem = isPlaybackQueueInitialized && (playbackQueueInitializationItemID == item.id)
            
            if !isPlaybackQueueInitializedForSpecifiedItem {
                let musicPlayer = self.musicPlayer
                
                setQueue(for: [item])
                isPlaybackQueueInitialized = true
                playbackQueueInitializationItemID = item.id
                
                Task {
                    do {
                        try await musicPlayer.play()
                    } catch {
                        print("Failed to prepare music player to play \(item).")
                    }
                }
            }
            else {
                Task {
                    try? await musicPlayer.play()
                }
            }
        }
        else {
            musicPlayer.pause()
        }
    }
    
    func togglePlaybackStatus() {
        if !isPlaying {
            Task {
                try? await musicPlayer.play()
            }
        } else {
            musicPlayer.pause()
        }
    }
    
    func playTrackWithRecommendedList(_ track: Track) {
        let model = NextMusicRecommendationModel()
        
        // 개별 트랙 재생
        play(track, in: nil, with: nil)
        
        // 추천 트랙 추가
        Task {
            let recommendedList = try await model.requestNextMusicList()
            if let recommendedList {
                try await ApplicationMusicPlayer.shared.queue.insert(recommendedList, position: .tail)
            }
        }
    }
    
    
    /// 🐯 유저가 새로운 플레이 리스트를 요구할 때 사용하는 메서드
    func playRandomMusic() async {
        let model = NextMusicRecommendationModel()
        
        /// 추천 트랙 추가
        Task {
            let recommendedList = try await model.requestNextMusicList()
            if let recommendedList {
                play(recommendedList[0], in: recommendedList, with: nil)
            }
        }
    }
    
    
    /// 🐯 특정 음악과 관련된 앨범을 통해 다음 노래로 재생할 Track 타입의 배열을 리턴해주는 메서드
    /// - Parameter song: 어떤 Song과 관련된 노래를 받을 지를 전달한다.
    /// - Returns: 특정 노래와 연관된 Track 배열
    private func getRelatedSongs(_ song: Song) async throws -> MusicItemCollection<Track>? {
        // 관련 앨범 가져오기
        let songAlbums = try await song.with([.albums])
        
        let relatedAlbums = try await songAlbums.albums?[0].with([.relatedAlbums])
        guard let albums = relatedAlbums?.relatedAlbums else {
            print("🚫 Related Albums Problem")
            return nil
        }
        
        var allTracks: [Track] = []
        
        // 각 앨범의 트랙 가져오기
        for album in albums {
            let detailedAlbum = try await album.with([.tracks])
            guard let tracks = detailedAlbum.tracks else {
                print("🚫 Related Albums Tracks Problem")
                return nil
            }
            // "(Instrumental)"이 포함된 트랙을 필터링하여 추가
            let filteredTracks = filterInstrumentalTracks(from: tracks)
            allTracks.append(contentsOf: filteredTracks)
        }
        
        allTracks.shuffle()
        return MusicItemCollection(allTracks)
    }
    
    
    /// 🐯특정 앨범과 관련된 다음 노래로 재생할 Track 타입의 배열을 리턴해주는 메서드
    /// - Parameter album: 어떤 Album과 관련된 노래를 받을 지를 전달한다.
    /// - Returns: 특정 앨범과 연관된 Track 배열
    private func getRelatedSongs(_ album: Album) async throws -> MusicItemCollection<Track>? {
        // 관련 앨범 가져오기
        let relatedAlbums = try await album.with([.relatedAlbums])
        guard let albums = relatedAlbums.relatedAlbums else {
            print("🚫 Related Albums Problem")
            return nil
        }
        
        var allTracks: [Track] = []
        
        // 각 앨범의 트랙 가져오기
        for album in albums {
            let detailedAlbum = try await album.with([.tracks])
            guard let tracks = detailedAlbum.tracks else {
                print("🚫 Related Albums Tracks Problem")
                return nil
            }
            // "(Instrumental)"이 포함된 트랙을 필터링하여 추가
            let filteredTracks = filterInstrumentalTracks(from: tracks)
            allTracks.append(contentsOf: filteredTracks)
        }
        
        allTracks.shuffle()
        return MusicItemCollection(allTracks)
    }
    
    /// 🐯 특정 노래를 재생하고 그 뒤에 추천 플레이리스트 붙여주기
    /// - Parameter song: 관련된 노래를 찾을 때 사용할 노래
    func playMusicWithRecommendedList(_ song: Song) {
        let track = fromSongToTrackType(song)
        
        // 개별 곡 재생
        play(track, in: nil, with: nil)
        
        // 추천 트랙 추가
        Task {
            let recommendedList = try await getRelatedSongs(song)
            if let recommendedList {
                try await ApplicationMusicPlayer.shared.queue.insert(recommendedList, position: .tail)
            }
        }
    }
    
    
    /// 🐯 앨범 전체 재생하고 그 뒤에 추천 플레이리스트 붙여주기
    /// - Parameter tracks: 사용자가 선택한 전체 재생할 앨범에 담긴 트랙
    /// - Parameter album: 관련된 노래를 찾을 때 사용할 앨범
    func playAlbumWithRecommendedList(_ tracks: MusicItemCollection<Track>, album: Album) {
        // ⁉️호랑: 이후에 DetailedAlbumModel에서 진행중인 로직을 여기다가 합칠 지 고민해보기 -> 현재는 앨범을 통해 트랙 배열을 받고 해당 메서드에 파라미터로 사용하는 로직
        
        // 앨범 재생
        play(tracks[0], in: tracks, with: nil)
        
        // 추천 트랙 추가
        Task {
            let recommendedList = try await getRelatedSongs(album)
            if let recommendedList {
                try await ApplicationMusicPlayer.shared.queue.insert(recommendedList, position: .tail)
            }
        }
    }
    
    /// ⭐️ 함께 활용할 함수 ⭐️
    /// 파라미터 1: 시작할 곡, 2: 트랙리스트 (곡 리스트), 3: 모르겠음
    private func play(_ track: Track, in trackList: MusicItemCollection<Track>?, with parentCollectionID: MusicItemID?) {
        let musicPlayer = self.musicPlayer
        
        if let specifiedTrackList = trackList {
            /// 개별 재생
            setQueue(for: specifiedTrackList, startingAt: track)
        } else {
            setQueue(for: [track])
        }
        
        isPlaybackQueueInitialized = true
        playbackQueueInitializationItemID = parentCollectionID
        
        Task {
            do {
                try await musicPlayer.play()
            } catch {
                print("Failed to prepare music player to play \(track).")
            }
        }
    }
    
    /// 🐯 instrumental를 제목에 포함한 트랙을 필터링하는 메서드
    /// - Parameter tracks: 필터링할 트랙 배열
    /// - Returns: 필터링된 트랙 배열
    private func filterInstrumentalTracks(from tracks: MusicItemCollection<Track>) -> [Track] {
        return tracks.filter { track in
            // 대, 소문자 구분 없이 제외
            return track.title.range(of: "(instrumental)", options: .caseInsensitive) == nil
        }
    }
    
    /// (추가) song -> Track 컨버터
    private func sendToMusicPlayer(_ song: Song) {
        let track = Track.song(song)
        play(track, in: nil, with: nil)
    }
    
    /// 🐰 Song 타입을 Track 타입으로 변경
    /// - Parameter song: Track 타입으로 변경할 Song
    /// - Returns: 전달받은 Song을 Track 타입으로 변환 후 반환
    private func fromSongToTrackType(_ song: Song) -> Track {
        Track.song(song)
    }
    
    /// (추가) 다음곡으로 넘기기!
    func skipToNextEntry() {
        Task {
            do {
                try await musicPlayer.skipToNextEntry()
            } catch {
                print("Failed to skip to the next entry: \(error)")
            }
        }
    }
    
    private func setQueue<S: Sequence, PlayableMusicItemType: PlayableMusicItem>(
        for playableItems: S,
        startingAt startPlayableItem: S.Element? = nil
    ) where S.Element == PlayableMusicItemType {
        ApplicationMusicPlayer.shared.queue = ApplicationMusicPlayer.Queue(for: playableItems, startingAt: startPlayableItem)
    }
    
    private func handlePlaybackStateDidChange() {
        isPlaying = (musicPlayer.state.playbackStatus == .playing)
    }
    
}

