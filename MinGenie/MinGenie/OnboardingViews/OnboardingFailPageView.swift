//
//  OnboardingFailPageView.swift
//  MinGenie
//
//  Created by 김하준 on 5/23/24.
//

import SwiftUI

struct OnboardingFailPageView: View {
    let title: String
    let imageName: String
    
    var body: some View {
        ZStack {
            Color.BG.main.ignoresSafeArea()
            
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Text.orange)
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
    OnboardingFailPageView(title: "title", imageName: "shaking")
}
