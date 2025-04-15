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
    }
}
