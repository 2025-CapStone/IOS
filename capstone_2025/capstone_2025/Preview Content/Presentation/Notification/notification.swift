//
//  NotificationCardView.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/22/25.
//
import SwiftUI

struct NotificationView: View {
    @ObservedObject var viewModel: NotificationViewModel = AppState.shared.notificationViewModel
    @State private var showErrorAlert = false
    @EnvironmentObject var router: NavigationRouter  // ✅ router 주입

    var body: some View {
        VStack(spacing: 16) {

            // ✅ 상단 바
            HStack {
                Image("ball")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        // ✅ 이전 화면으로 돌아가기
                        if !router.path.isEmpty {
                            router.path.removeLast()
                        }
                    }

                Text("전체 알림")
                    .font(.custom("Comfortaa-Bold", size: 24))

                Spacer()

                Button("🔄 새로고침") {
                    viewModel.fetchAll()
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // ✅ 내용
            if viewModel.notifications.isEmpty {
                VStack(spacing: 8) {
                    Text("📭")
                        .font(.system(size: 40))
                    Text("도착한 쪽지가 없습니다.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.notifications) { noti in
                            NotificationCardView(
                                notification: noti,
                                onClick: {
                                    viewModel.markAsRead(id: noti.id)
                                    viewModel.select(noti)
                                },
                                onDelete: {
                                    viewModel.deleteNotification(id: noti.id)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.fetchAll()
        }
        .sheet(item: $viewModel.selectedNotification) { noti in
            NotificationDetailModal(notification: noti)
        }
        .alert("오류", isPresented: $showErrorAlert, actions: {
            Button("확인", role: .cancel) {}
        }, message: {
            Text(viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.")
        })
        .onChange(of: viewModel.errorMessage) { _ in
            if viewModel.errorMessage != nil {
                showErrorAlert = true
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .environmentObject(NavigationRouter()) // ✅ router 주입 필요
            .previewDevice("iPhone 15")
    }
}
