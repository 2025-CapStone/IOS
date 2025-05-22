//
//  AppState.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 4/6/25.
//

//import Combine
//import Foundation
//
//
//final class AppState: ObservableObject {
//    static let shared = AppState()
//    private init() {
//        self.isLoggedIn = UserDefaults.standard.string(forKey: "accessToken") != nil
//    }
//
//    @Published var userId: Int? = nil
//    @Published var isLoggedIn: Bool = false
//}
import Combine
import Foundation

final class AppState: ObservableObject {
    static let shared = AppState()
    private init() {
        self.isLoggedIn = UserDefaults.standard.string(forKey: "accessToken") != nil
    }
    
    @Published var user: User? = nil
    @Published var isLoggedIn: Bool = false
    @Published var loginViewmodel : LoginViewModel = AppDIContainer.shared.makeLoginViewModel()
    @Published var notificationViewModel: NotificationViewModel = AppDIContainer.shared.makeNotificationViewModel()
    @Published var clubListViewModel : ClubListViewModel = AppDIContainer.shared.makeClubListViewModel()

    
}
