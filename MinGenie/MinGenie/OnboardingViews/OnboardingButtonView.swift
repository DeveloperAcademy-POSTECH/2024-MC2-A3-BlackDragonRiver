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
    
    var body: some View {
        ZStack {
            VStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("text/Blue"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .frame(width: 300, height: 120, alignment: .bottom)
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 40, trailing: 0))
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 361, height: 200)
                Spacer()
            }
       
        VStack{
                Spacer()
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                Button { //다음 페이지로 넘어가거나 권한받기
                } label: {
                    Text("다음")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 361, height: 50)
                        .background(Color.black)
                        .cornerRadius(16)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 160, trailing: 0))
                }
            }
        }
    }
}
