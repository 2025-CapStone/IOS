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
    case calendar
    case budget//(예산관리)
    case member
//    case clubEdit
}

// ✅ 네비게이션 상태를 관리하는 ObservableObject
class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
}


struct ContentView: View {
    @StateObject var router = NavigationRouter()   // 네비게이션 상태 관리
    
    var body: some View {
        NavigationStack(path: $router.path) {
            onboarding()
                .environmentObject(router)         // ✅ 네비게이션 객체 추가
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .member:
                        member()
                            .environmentObject(router)
                    case .budget:
                        budget()
                            .environmentObject(router)
                    case .calendar:
                        MainCalendarView()
                            .environmentObject(router)
                    case .login:
                        Login(viewModel: AppDIContainer.shared.makeLoginViewModel())
                            .environmentObject(router)
                    case .signup:
                        SignUp(viewModel: AppDIContainer.shared.makeSignupViewModel())
                            .environmentObject(router)
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
                            .environmentObject(router)
                    case .onboarding:
                        onboarding()
                            .environmentObject(router)
                    case .introduce:
                        introduce()
                            .environmentObject(router)
//                    case .clubEdit:
//                        club_edit().environmentObject(router)
                    }
                }
        }
        .environmentObject(router) // ✅ 모든 뷰에서 NavigationRouter 사용 가능하도록 설정
     
    }
}

#Preview {
    ContentView()
           
}
