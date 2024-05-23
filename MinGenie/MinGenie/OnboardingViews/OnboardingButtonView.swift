//
//  OnboardingButtonView.swift
//  MinGenie
//
//  Created by Sunyoung Jeon  on 5/22/24.
//

import SwiftUI

struct OnboardingButtonView: View {
    let title: String
    let imageName: String
    let text: String
    @Binding var currentPage: Int

    
    var body: some View {
        ZStack {
            VStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .frame(width: 300, height: 120, alignment: .bottom)
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 40, trailing: 0))
                GifImage(imageName)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 361, height: 200)
                Spacer()
            }
       
        VStack{
                Spacer()
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                Button {
                    currentPage += 1

                } label: {
                    Text("다음")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 361, height: 50)
                        .background(Color.black)
                        .cornerRadius(16)
                        .padding(.bottom, 160)
                }
            }
        }
    }
}
