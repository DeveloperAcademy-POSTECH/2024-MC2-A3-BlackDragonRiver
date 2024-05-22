//
//  OnboardingTabView.swift
//  MinGenie
//
//  Created by Sunyoung Jeon  on 5/22/24.
//

import SwiftUI
import Combine


struct OnboardingTabView: View {
    @Binding var hasSeenOnboarding: Bool
    @StateObject private var shakeDetectionModel = ShakeDetectionModel()
    @State private var currentPage = 0
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        TabView(selection: $currentPage){
            
            // 페이지 1: 온보딩 시작
            OnboardingPageView(
                title: "반갑습니다! 복숭K님, \n업무환경에 딱 맞는 \n음악을 추천드릴께요!",
                imageName: "headphone" //뷰마다 GIF 이름 넣기
            )
            .tag(0)

            
            // 페이지 2: 애플뮤직 연결 권한 허용
            OnboardingButtonView(
                title: "이제 복숭K님의 \n애플 뮤직을 연결할게요",
                imageName: "headphone",
                text: "권한을 허용해야 음악 재생목록이 연결돼요"
            )
            .tag(1)

            
            // 페이지 3: 애플뮤직 연결 권한 허용
            OnboardingButtonView(
                title: "손쉬운 곡 변경을 위해 \n모션 권한을 허용해 주세요!",
                imageName: "headphone",
                text: "권한을 허용해야 흔들 수 있어요"
            )
            .tag(2)

            
            // 페이지 4: 핸드폰 뒷면 흔들기 안내
            OnboardingButtonView(
                title: "핸드폰 화면이 바닥을 \n향한 채로 좌우로 흔들면 \n노래가 교체돼요!",
                imageName: "headphone",
                text: "권한을 허용해야 흔들 수 있어요"
            )
            .tag(3)

            // 페이지 5: 뒷면 흔들기 시도
            OnboardingPageView(
                title: "직접 좌우로 \n흔들어보세요!",
                imageName: "headphone"
            )
            .tag(4)
            .onAppear {
                shakeDetectionModel.startDetection()
            }
            
            // 페이지 6: 뒷면 흔들기 실패
            OnboardingPageView(
                title: "다시 한번 시도해 주세요!",
                imageName: "headphone"
            )
            .tag(5)

            // 페이지 7: 뒷면 흔들기 성공
            OnboardingPageView(
                title: "정말 잘하셨어요!",
                imageName: "headphone"
            )
            .tag(6)
            .onAppear {
                shakeDetectionModel.startDetection()
            }
            
            
            // 페이지 8: 온보딩 완료
            OnboardingLastPageView(
                title: "음악과 함께 \n일할 준비가 되셨나요?",
                imageName: "headphone",
                hasSeenOnboarding: $hasSeenOnboarding
                )
            .tag(7)

        }
        .tabViewStyle(PageTabViewStyle())
                .onAppear {
                    shakeDetectionModel.startDetection()
                    
                    // 감지 성공 시
                    shakeDetectionModel.$shakeDetected
                        .filter { $0 }
                        .sink { _ in
                            if currentPage == 4 {
                                currentPage = 6 // 페이지 7로 이동
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    currentPage = 7 // 페이지 8로 이동
                                }
                            } else if currentPage == 5 {
                                currentPage = 6 // 페이지 7로 이동
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    currentPage = 7 // 페이지 8로 이동
                                }
                            }
                        }
                        .store(in: &cancellables)
                    
                    // 감지 실패 시
                    shakeDetectionModel.$shakeFailed
                        .filter { $0 }
                        .sink { _ in
                            if currentPage == 4 {
                                currentPage = 5 // 페이지 6로 이동
                            } else if currentPage == 5 {
                                shakeDetectionModel.startDetection() // 다시 감지 시작
                            }
                        }
                        .store(in: &cancellables)
                }
                .onDisappear {
                    shakeDetectionModel.stopDetection()
                    cancellables.removeAll()
                }

        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
