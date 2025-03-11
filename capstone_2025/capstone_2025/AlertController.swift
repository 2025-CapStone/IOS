//
//  AlertController.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 3/12/25.
//


import SwiftUI

// 간단한 확인 알림

import SwiftUI

// ✅ Custom Alert를 전역적으로 관리하는 ObservableObject
class CustomAlertManager: ObservableObject {
    @Published var isPresented: Bool = false  // Alert 표시 여부
    @Published var title: String = "알림"
    @Published var message: String = "기본 메시지"
    @Published var confirmAction: (() -> Void)?  // 확인 버튼 액션
    @Published var cancelAction: (() -> Void)?  // 취소 버튼 액션
    @Published var hasTwoButtons: Bool = false  // 두 개의 버튼이 있는지 여부
    
    // ✅ Alert 설정 함수
    func setAlert(title: String, message: String, action: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.confirmAction = action
        self.isPresented = true
    }
    
    
    
    // ✅ 두 개의 버튼이 있는 Alert 설정 함수
        func setDualButtonAlert(
            title: String,
            message: String,
            confirmAction: (() -> Void)? = nil,
            cancelAction: (() -> Void)? = nil
        ) {
            self.title = title
            self.message = message
            self.confirmAction = confirmAction
            self.cancelAction = cancelAction
            self.hasTwoButtons = true
            self.isPresented = true
        }
    
    
    
    
//    func showSimpleAlert() {
//        let alert = UIAlertController(
//            title: "완료",
//            message: "작업이 성공적으로 완료되었습니다.",
//            preferredStyle: .alert
//        )
//        
//        alert.addAction(UIAlertAction(title: "확인", style: .default))
//        present(alert, animated: true)
//    }
//    
//    // 삭제 확인 알림
//    func showDeleteAlert() {
//        let alert = UIAlertController(
//            title: "삭제 확인",
//            message: "정말로 삭제하시겠습니까?",
//            preferredStyle: .alert
//        )
//        
//        alert.addAction(UIAlertAction(
//            title: "삭제",
//            style: .destructive
//        ) { _ in
//            // 삭제 로직 구현
//        })
//        
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
//        present(alert, animated: true)
//    }
}
struct CustomAlertView1: View {
    @EnvironmentObject var alertManager: CustomAlertManager  // 전역 Alert 객체

    var body: some View {
        VStack {}
            .alert(isPresented: $alertManager.isPresented) {
                if alertManager.hasTwoButtons {
                    // ✅ 두 개의 버튼이 있는 Alert
                    return Alert(
                        title: Text(alertManager.title),
                        message: Text(alertManager.message),
                        primaryButton: .default(Text("확인"), action: {
                            alertManager.confirmAction?()
                        }),
                        secondaryButton: .cancel(Text("취소"), action: {
                            alertManager.cancelAction?()
                        })
                    )
                } else {
                    // ✅ 기본 Alert (단일 버튼)
                    return Alert(
                        title: Text(alertManager.title),
                        message: Text(alertManager.message),
                        dismissButton: .default(Text("확인"), action: {
                            alertManager.confirmAction?()
                        })
                    )
                }
            }
    }
}
func createAlert(
    title: String,
    message: String,
    confirmAction: @escaping () -> Void,
    cancelAction: @escaping () -> Void
) -> Alert {
    Alert(
        title: Text(title),
        message: Text(message),
        primaryButton: .destructive(Text("Yes"), action: confirmAction),
        secondaryButton: .cancel(Text("No"), action: cancelAction)
    )
}

import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .padding(.top, 10)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            HStack {
                Button(action: onCancel) {
                    Text("No")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: onConfirm) {
                    Text("Yes")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
