//
//  JoinClubPopupView.swift
//  capstone_2025
//
//  Created by Yoon on 5/12/25.
//

import SwiftUI

/// ⬆️ 스크린샷과 비슷한 모달 팝업
struct JoinClubPopupView: View {
    @Binding var isVisible: Bool          // 외부에서 on/off 제어
    var onJoin: (String) -> Void          // "참가" 버튼 액션

    @State private var clubIdText = ""    // 입력받을 클럽 ID

    var body: some View {
        ZStack {
            // 반투명 딤(background tap => 닫기)
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isVisible = false }

            VStack(spacing: 16) {
                // 상단 이미지 (원하는 이미지를 프로젝트에 넣어 두세요)
                Image("popupHeader")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()

                // 안내문
                Text("참가할 클럽의 ID를 입력하세요")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // 클럽 ID 입력
                TextField("클럽 ID", text: $clubIdText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding(.horizontal, 24)

                // 버튼 2개
                HStack(spacing: 40) {
                    Button("참가") {              // (= 참가)
                        onJoin(clubIdText)
                    }
                    Button("닫기") {               // (= 닫기)
                        isVisible = false
                    }
                }
                .font(.system(size: 14, weight: .semibold))
                .padding(.bottom, 12)
            }
            .frame(width: 260)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 6)
        }
    }
}
