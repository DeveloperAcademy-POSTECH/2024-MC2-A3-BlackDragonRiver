//
//  OnboardingTabView.swift
//  MinGenie
//
//  Created by Sunyoung Jeon  on 5/22/24.
//

import Combine
import SwiftUI

struct OnboardingTabView: View {
    @Binding var hasSeenOnboarding: Bool
    @StateObject private var shakeDetectionModel = ShakeDetectionModel()
    @State private var currentPage = 0
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            ZStack {
                if currentPage == 0 {
                    OnboardingPageView(
                        title: "반갑습니다! 복숭K님, \n업무환경에 딱 맞는 \n음악을 추천드릴께요!",
                        imageName: "headphone"
                    )
                } else if currentPage == 1 {
                    OnboardingButtonView(
                        title: "이제 복숭K님의 \n애플 뮤직을 연결할게요",
                        imageName: "headphone",
                        text: "권한을 허용해야 음악 재생목록이 연결돼요",
                        currentPage: $currentPage
                    )
                } else if currentPage == 2 {
                    OnboardingButtonView(
                        title: "손쉬운 곡 변경을 위해 \n모션 권한을 허용해 주세요!",
                        imageName: "headphone",
                        text: "권한을 허용해야 흔들 수 있어요",
                        currentPage: $currentPage
                    )
                } else if currentPage == 3 {
                    OnboardingButtonView(
                        title: "핸드폰 화면이 바닥을 \n향한 채로 좌우로 흔들면 \n노래가 교체돼요!",
                        imageName: "headphone",
                        text: "권한을 허용해야 흔들 수 있어요",
                        currentPage: $currentPage
                    )
                } else if currentPage == 4 {
                    OnboardingPageView(
                        title: "직접 좌우로 \n흔들어보세요!",
                        imageName: "headphone"
                    )
                    .onAppear {
                        shakeDetectionModel.startDetection()
                    }
                } else if currentPage == 5 {
                    OnboardingPageView(
                        title: "다시 한번 시도해 주세요!",
                        imageName: "headphone"
                    )
                } else if currentPage == 6 {
                    OnboardingPageView(
                        title: "정말 잘하셨어요!",
                        imageName: "headphone"
                    )
                    .onAppear {
                        shakeDetectionModel.startDetection()
                    }
                } else if currentPage == 7 {
                    OnboardingLastPageView(
                        title: "음악과 함께 \n일할 준비가 되셨나요?",
                        imageName: "headphone",
                        hasSeenOnboarding: $hasSeenOnboarding
                    )
                }
            }
            .animation(.easeInOut, value: currentPage) // 애니메이션 효과( 시작과 끝부분이 부드럽게 진행되며, 중간 부분이 빠르게 진행)
            .transition(.slide)//스와이프 애니메이션
            HStack(spacing: 8) {//페이지 인디케이터(페이지 확인하는거)
                ForEach(0..<8) { index in
                    Circle()
                        .fill(index == currentPage ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(10)
            .background(Capsule().fill(Color.gray.opacity(0.2)).frame(height: 20))
            .padding(.horizontal, 50)
        }
        .contentShape(Rectangle()) // 전체 영역을 제스처 감지 영역으로 설정
        .gesture(//드래그 제스처(스와이프) 감지 및 작동 확인 : 범위에 없으면 작동하지 않음
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {//제스처(음수:왼, 양수:오)
                                if currentPage == 0 || currentPage > 5 {//페이지
                                    currentPage += 1
                                }
                            } else if value.translation.width > 50 {
                                if currentPage > 0 {
                                    currentPage -= 1
                                }
                            }
                        }
                )
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
    }
}
