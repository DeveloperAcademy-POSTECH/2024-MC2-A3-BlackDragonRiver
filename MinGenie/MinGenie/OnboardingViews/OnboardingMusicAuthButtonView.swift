//
//  OnboardingMusicAuthButtonView.swift
//  MinGenie
//
//  Created by Sunyoung Jeon  on 5/22/24.
//

import SwiftUI

struct OnboardingMusicAuthButtonView: View {
    @ObservedObject var model: MusicAuthorizationModel
    
    @Binding var currentPage: Int
    
    let title: String
    let imageName: String
    let text: String

    var body: some View {
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
       
        VStack {
                Spacer()
            
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(Color.Text.gray50)
            
                Button {
                    model.requestMusicAuthorizationStatus(currentPage: $currentPage)

                } label: {
                    Text("다음")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.Text.white100)
                        .frame(width: 361, height: 50)
                        .background(Color.Shape.black)
                        .cornerRadius(16)
                }
                .padding(.bottom, 160)

            }
        }
    }
}
