
//  ContentView.swift
//  capstone_2025
//
//  Created by Yoon on 2/18/25.
//


import SwiftUI

enum AppRoute: Hashable {
    case login
    case introduce1
    case introduce2
    case introduce3
    // 예시: 다른 뷰(데이터 전달이 필요한 경우)
    case home/*(data: String)*/
    case signup
    case onboarding
    case introduce
}

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
}


struct ContentView: View {
    @StateObject var router = NavigationRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            // 초기 뷰: introduce1을 보여줍니다.
            onboarding()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .login:
                        Login() // 로그인 뷰 (추후 정의)
                    case .introduce1:
                        introduce_1()
                    case .introduce2:
                        introduce_2()
                    case .introduce3:
                        introduce_3()
                    case .home/*(let data)*/:
                        home(/*data: data*/) // 예시: 데이터 전달받는 Home 뷰
                        // HTTP 프로토콜을 사용해야 하는 부분!
                    case .signup:
                        SignUp()
                    case .onboarding:
                        onboarding()
                    case .introduce:
                        introduce()
                    }
                }
        }
        .environmentObject(router) // 모든 자식 뷰에서 router에 접근할 수 있도록 설정
    }
}

extension ContentView{
    

    }


#Preview {
    ContentView()
}

