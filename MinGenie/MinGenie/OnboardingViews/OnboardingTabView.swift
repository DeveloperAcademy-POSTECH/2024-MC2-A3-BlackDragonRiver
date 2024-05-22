//
//  OnboardingTabView.swift
//  MinGenie
//
//  Created by Sunyoung Jeon  on 5/22/24.
//

import SwiftUI

struct OnboardingTabView: View {
    @Binding var isFirstLaunching: Bool
    
    var body: some View {
        TabView {
            
            // 페이지 1: 온보딩 시작
            OnboardingPageView(
                title: "반갑습니다! 복숭K님, \n업무환경에 딱 맞는 \n음악을 추천드릴께요!",
                imageName: "macbook.png"
            )
            
            // 페이지 2: 애플뮤직 연결 권한 허용
            OnboardingButtonView(
                title: "이제 복숭K님의 \n애플 뮤직을 연결할게요",
                imageName: "macbook.png",
                text: "권한을 허용해야 음악 재생목록이 연결돼요"
            )
            
            // 페이지 3: 애플뮤직 연결 권한 허용
            OnboardingButtonView(
                title: "손쉬운 곡 변경을 위해 \n모션 권한을 허용해 주세요!",
                imageName: "macbook.png",
                text: "권한을 허용해야 흔들 수 있어요"
            )
            
            // 페이지 4: 핸드폰 뒷면 두드리기 안내
            OnboardingButtonView(
                title: "핸드폰 화면이 바닥을 \n향한 채로 좌우로 흔들면 \n노래가 교체돼요!",
                imageName: "macbook.png",
                text: "권한을 허용해야 흔들 수 있어요"
            )
            
            // 페이지 5: 뒷면 두드리기
            OnboardingPageView(
                title: "직접 좌우로 \n흔들어보세요!",
                imageName: "macbook.png"
            )
            
            // 페이지 6: 뒷면 두드리기 실패
            OnboardingPageView(
                title: "다시 한번 시도해 주세요!",
                imageName: "macbook.png"
            )
            
            // 페이지 6: 뒷면 두드리기 성공
            OnboardingPageView(
                title: "정말 잘하셨어요!",
                imageName: "macbook.png"
            )
            
            // 페이지 7: 온보딩 완료
            OnboardingLastPageView(
                title: "음악과 함께 \n일할 준비가 되셨나요?",
                imageName: "macbook.png",
                isFirstLaunching: $isFirstLaunching
                )
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
