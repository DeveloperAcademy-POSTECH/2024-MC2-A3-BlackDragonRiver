import SwiftUI
import MusicKit



struct Item: Identifiable, Hashable{
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
    let song: Song
}


struct SearchView: View {
    @State var songs = [Item]()
    @ObservedObject var musicPlayer = MusicPlayer.shared

    var body: some View {
        VStack{
            Text("실리카겔 검색 결과")
                .font(.title3)
                .padding(.top)
            
            NavigationView {
                List(songs) { song in
                    HStack{
                        AsyncImage(url: song.imageUrl)
                            .frame(width: 75, height: 75, alignment: .center)
                        VStack(alignment: .leading){
                            Text(song.name)
                                .font(.title3)
                            Text(song.artist)
                                .font(.footnote)
                        }
                        .padding()
                    }
                    .onTapGesture {
                        sendToMusicPlayer(song.song)
                    }
                   
                }
            }
            .onAppear{
                fetchMusic()
            }
        }
    }
    
    private let request: MusicCatalogSearchRequest = {
        
        var request = MusicCatalogSearchRequest(term: "Silicagel",
                                                types: [Song.self])
        request.limit = 25
        return request
    }()
    
    private func fetchMusic(){
        Task{
            // Request permission
            let status = await MusicAuthorization.request()
            
            switch status{
                case .authorized:
                // Request -> Reponse
                do {
                    let result = try await request.response()
                    self.songs = result.songs.compactMap({
                        return .init(name: $0.title,
                                     artist: $0.artistName,
                                     imageUrl: $0.artwork?.url(width: 75, height: 75),
                                     song: $0.self)
                    })
                    
                }catch{
                    print(String(describing: error))
                }
                // Assigns songs
            default:
                break
            }
            
            
        }
    }
    
    // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️ musicPlayer.play함수는 Track을 받음.
    // 이런 식으로 track형으로 변환하는 함수 만들어 사용해 주삼

    func sendToMusicPlayer(_ song: Song) {
        // Song >> Track
        let track = Track.song(song)
        musicPlayer.play(track, in: nil, with: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
