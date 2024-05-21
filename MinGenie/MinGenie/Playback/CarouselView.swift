import SwiftUI

struct Item2: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let color: Color
}

struct CarouselView: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State var songs: [Item2] = []
    
    private let colors: [Color] = [.gray, .purple, .red, .yellow, .orange]
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(0..<colors.count, id: \.self) { index in
                        Rectangle()
                            .foregroundColor(colors[index])
                            .frame(width: 250, height: 250)
                            .opacity(1.0 - Double(abs(index - currentIndex)) * 0.2)
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
                                .frame(width: 75, height: 75, alignment: .center)
                            VStack(alignment: .leading) {
                                Text("Song " + song.name)
                                    .font(.title3)
                                Text("Artist " + song.name) // 더미 데이터이므로 같은 이름을 두 번 표시합니다.
                                    .font(.footnote)
                            }
                        }
                    }
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
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                currentIndex = min(colors.count - 1, currentIndex + 1)
                            }
                        } label: {
                            Image(systemName: "arrow.right")
                                .font(.title)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
