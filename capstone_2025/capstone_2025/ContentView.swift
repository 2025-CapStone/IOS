import SwiftUI

// ✅ 앱 내 네비게이션 경로를 관리하는 Enum
enum AppRoute: Hashable {
    case login
    case introduce1
    case introduce2
    case introduce3
    case home
    case signup
    case onboarding
    case introduce
    case calender
}

// ✅ 네비게이션 상태를 관리하는 ObservableObject
class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
}

struct ContentView: View {
    @StateObject var router = NavigationRouter() // ✅ 네비게이션 상태 객체 생성

    var body: some View {
        NavigationStack(path: $router.path) {
            onboarding() // ✅ 초기 뷰를 `onboarding()`으로 설정
                .environmentObject(router) // ✅ 모든 뷰에서 `router`를 사용할 수 있도록 설정
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    
                    case .calender:
                        MainCalendarView()
                            .environmentObject(router)
                    case .login:
                        Login()
                            .environmentObject(router) // ✅ Login 화면에도 environmentObject 추가
                    case .introduce1:
                        introduce_1()
                            .environmentObject(router)
                    case .introduce2:
                        introduce_2()
                            .environmentObject(router)
                    case .introduce3:
                        introduce_3()
                            .environmentObject(router)
                    case .home:
                        home()
                            .environmentObject(router) // ✅ home 화면에서도 router 사용 가능
                    case .signup:
                        SignUp()
                            .environmentObject(router) // ✅ SignUp 화면에서도 router 사용 가능
                    case .onboarding:
                        onboarding()
                            .environmentObject(router)
                    case .introduce:
                        introduce()
                            .environmentObject(router)
                    }
                }
        }
        .environmentObject(router) // ✅ 모든 뷰에서 NavigationRouter 사용 가능하도록 설정
    }
}

#Preview {
    ContentView()
}
