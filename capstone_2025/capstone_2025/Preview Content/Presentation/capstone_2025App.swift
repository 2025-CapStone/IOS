//
//  capstone_2025App.swift
//  capstone_2025
//
//  Created by Yoon on 2/18/25.
//

//import SwiftUI
//
//@main
//struct capstone_2025App: App {
//
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
import SwiftUI

@main
struct capstone_2025App: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appState = AppState.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate


    init() {
        // ✅ 앱 시작 시 토큰 초기화 (디버깅/테스트 목적)
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        print("🧼 초기화: accessToken, refreshToken 제거 완료")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                print("📲 [AppState] 앱 활성화됨")
                logSessionInfo()
                let status = AppState.shared.getPushAuthorization()
                if status == .denied {
//                    알림창(title: "푸쉬 알림을 해주세요", style: .destructive){_ in 
//                                      DispatchQueue.main.async {
//                                          if let appSettings = URL(string: UIApplication.openSettingsURLString),
//                                             UIApplication.shared.canOpenURL(appSettings) {
//                                              UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//                                          }
//                                      }
//                    }
                    
                    
                }

            case .inactive:
                print("⏸ [AppState] 앱 비활성화됨")

            case .background:
                print("📤 [AppState] 앱 백그라운드 진입")
                logSessionInfo()

            @unknown default:
                print("⚠️ [AppState] 알 수 없는 상태")
            }
        }
    }
     func logSessionInfo() {
        let isLoggedIn = appState.isLoggedIn
        let userId = appState.user?.id ?? "Default UserId"
        let accessToken = SessionStorage.shared.accessToken ?? "nil"
        let refreshToken = SessionStorage.shared.refreshToken ?? "nil"

        print("""
        🔐 [AppState] 로그인 상태: \(isLoggedIn)
        👤 [AppState] 사용자 ID: \(userId)
        🔑 accessToken: \(accessToken)
        ♻️ refreshToken: \(refreshToken)
        """)
    }
}
