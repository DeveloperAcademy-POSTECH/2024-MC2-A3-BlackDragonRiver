//
//  OnboardingPageView.swift
//  MinGenie
//
//  Created by Sunyoung Jeon  on 5/22/24.
//

import SwiftUI

struct OnboardingPageView: View {
    let title: String
    let imageName: String
    
    var body: some View {
        // 방법 1
        ZStack {
            Color.BG.main.ignoresSafeArea()
            
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Text.blue)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .frame(width: 300, height: 120, alignment: .bottom)
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 40, trailing: 0))
                
                GifImage(imageName)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 361, height: 200)
                
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingPageView(title: "d", imageName: "shaking")
}
