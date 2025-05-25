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
import UserNotifications

final class AppState: ObservableObject {
    static let shared = AppState()
    private init() {
        self.isLoggedIn = UserDefaults.standard.string(forKey: "accessToken") != nil
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"){
            self.DeviceToken = deviceToken
        }else{ self.DeviceToken = "none"}
        print("Test AppState DeviceToken : \(DeviceToken!)")
        
    }
    
    @Published var user: User? = nil
    @Published var isLoggedIn: Bool = false
    @Published var loginViewmodel : LoginViewModel = AppDIContainer.shared.makeLoginViewModel()
    @Published var notificationViewModel: NotificationViewModel = AppDIContainer.shared.makeNotificationViewModel()
    @Published var clubListViewModel : ClubListViewModel = AppDIContainer.shared.makeClubListViewModel()
    
    private var DeviceToken: String?
    private var pushAuthorization : UNAuthorizationStatus?
    
    
    func getDeviceToken() -> String {
        
        guard let deviceToken = self.DeviceToken else{
            print("Test AppState DeviceToken : none")

            return "none"
        }
        print("Test AppState getDeviceToken : \(deviceToken)")

        return deviceToken
    }
    
    func setDeviceToken() {
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"){
            self.DeviceToken = deviceToken
        }else{ self.DeviceToken = "none"}
        print("Test AppState setDeviceToken : \(DeviceToken!)")
        
    }
    
    
    func getPushAuthorization() -> UNAuthorizationStatus {
        
        guard let pushAuthorization = self.pushAuthorization else{
            print("Test AppState getPushAuthorization : none")

            return UNAuthorizationStatus.denied
        }
        print("Test AppState getPushAuthorization : \(pushAuthorization)")

        return pushAuthorization
    }
    
    func setPushAuthorization(_PushAuth : UNAuthorizationStatus) {
        self.pushAuthorization = _PushAuth
        print("Test AppState setPushAuthorization : \(self.pushAuthorization!)")
        
    }
    

    

    
}
