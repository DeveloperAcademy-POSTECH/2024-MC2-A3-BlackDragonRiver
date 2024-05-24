//
//  ContentView.swift
//  audio_animation
//
//  Created by Sunyoung Jeon  on 5/16/24.
//

import SwiftUI

struct AnimationView: View {
 
    @State private var drawingHeight = true
 
    var animation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }
 
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                bar(low: 0.2)
                    .animation(animation.speed(0.7), value: drawingHeight)
                bar(low: 0.3)
                    .animation(animation.speed(1.2), value: drawingHeight)
                bar(low: 0.4)
                    .animation(animation.speed(1.5), value: drawingHeight)
                bar(low: 0.5)
                    .animation(animation.speed(1.9), value: drawingHeight)
            
            }
    
            .frame(width: 30, height: 20)
            .onAppear{
                drawingHeight.toggle()
            }
        }
    }
 
    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
         RoundedRectangle(cornerRadius: 10)
             .fill(Color("text/White100")) // Use the custom color
             .frame(height: (drawingHeight ? high : low) * 51)
     }
 }
#Preview {
    AnimationView()
}
