import MusicKit
import SwiftUI

struct Item2: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let color: Color
}

struct CarouselView: View {
    
    /// 현재 index
    @State private var currentIndex: Int = 0
    /// drag변화 감지할 수치
    @GestureState private var dragOffset: CGFloat = 0
    @State var songs: [Item2] = []
    
    private let colors: [Color] = [.gray, .purple, .red, .yellow, .orange]
    
    /// 5개씩 표시하고, 마지막인 경우에만 흰색을 올릴 예정
    
    var body: some View {
        
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(0..<colors.count, id: \.self) { index in
                        
                        Rectangle()
                            .foregroundColor(colors[index])
                            .frame(width: 264, height: 264)
                            .cornerRadius(16)
                            .scaleEffect(1.0 - CGFloat(abs(index - currentIndex)) * 0.1)
                            .zIndex(1.0 - Double(abs(index - currentIndex)) * 0.1)
                            .offset(x: CGFloat(index - currentIndex) * 50 * (1 - CGFloat(abs(index - currentIndex)) * 0.1) + dragOffset, y: 0)
                        
                        Rectangle()
                            .foregroundColor(.black)
                            .opacity(0.3)
                            .frame(width: 264, height: 264)
                            .cornerRadius(16)
                            .scaleEffect(1.0 - CGFloat(abs(index - currentIndex)) * 0.1)
                            .zIndex(1.0 - Double(abs(index - currentIndex)) * 0.1)
                            .offset(x: CGFloat(index - currentIndex) * 50 * (1 - CGFloat(abs(index - currentIndex)) * 0.1) + dragOffset, y: 0)
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                withAnimation {
                                    currentIndex = max(0, currentIndex - 1)
                                }
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    currentIndex = min(colors.count - 1, currentIndex + 1)
                                }
                            }
                        }
                )
                .padding(.top, 40)
                
                ScrollViewReader { proxy in
                    List(songs) { song in
                        HStack {
                            Rectangle()
                                .foregroundColor(song.color)
                                .cornerRadius(11)
                                .frame(width: 51, height: 51, alignment: .center)
                            VStack(alignment: .leading) {
                                Text("Song " + song.name)
                                    .font(.title3)
                                Text("Artist " + song.name)
                                    .font(.footnote)
                            }
                        }
                        .frame(height: 42)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())    /// List 배경 지우기
                    .onChange(of: currentIndex) { newIndex in
                        withAnimation {
                            proxy.scrollTo(songs[newIndex].id, anchor: .top)
                        }
                    }}
                .onAppear {
                    // 더미 데이터 추가
                    var dummySongs: [Item2] = []
                    for (index, color) in colors.enumerated() {
                        dummySongs.append(Item2(name: "\(index + 1)", color: color))
                    }
                    songs = dummySongs
                }
                
            }
            .navigationTitle("Carousel")
        }
    }
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
