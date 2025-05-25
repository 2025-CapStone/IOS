//
//  AppDelegate.swift
//  capstone_2025
//
//  Created by ㅇㅇ ㅇ on 5/24/25.
//

import ObjectiveC
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(checkNotificationSetting),
          name: UIApplication.willEnterForegroundNotification,
          object: nil
        )
        // 푸시 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("🔴 알림 권한 요청 오류: \(error.localizedDescription)")
            }
        }
        AppState.shared.setDeviceToken()
        print("Test AppDelegate DeviceToken didFinishLaunchingWithOptions setDeviceToken")
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("📱 deviceToken: \(token)")
        if let isStoreToken = UserDefaults.standard.string(forKey: "deviceToken") {
            let isSame = isStoreToken.compare("nil")==ComparisonResult.orderedSame
            if(isSame){
                print("Test AppDelegate  is  : \(isSame)")
                UserDefaults.standard.set(token, forKey: "deviceToken")
                print("Test AppDelegate  is  : \(token)")
                
            }
            print("Test AppDelegate didRegisterForRemoteNotificationsWithDeviceToken DeviceToken is Stored : \(UserDefaults.standard.string(forKey: "deviceToken"))")
        }
        
        
        
        else{
                UserDefaults.standard.set(token, forKey: "deviceToken")
                      print("Test AppDelegate didRegisterForRemoteNotificationsWithDeviceToken DeviceToken is now Stored : \(UserDefaults.standard.string(forKey: "deviceToken"))")
            }

        
        // 여기에 서버 전송 로직 추가 가능
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ 푸시 등록 실패: \(error.localizedDescription)")
    }
    @objc private func checkNotificationSetting() {
      UNUserNotificationCenter.current()
        .getNotificationSettings { permission in
            let Status = permission.authorizationStatus
            AppState.shared.setPushAuthorization(_PushAuth: Status)
          switch Status  {
          case .authorized:
              DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                  
              }
          case .denied:
            print("푸시 수신 거부")
//              DispatchQueue.main.async {
//                  if let appSettings = URL(string: UIApplication.openSettingsURLString),
//                     UIApplication.shared.canOpenURL(appSettings) {
//                      UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//                  }
//              }
             
              if let Token1 = UserDefaults.standard.string(forKey: "deviceToken"){
                  let isSame = Token1.compare("nil")==ComparisonResult.orderedSame
                  if(isSame){
                  }
                  else{ UserDefaults.standard.set("nil", forKey: "deviceToken")
                      print("Test AppDelegate checkNotificationSetting .denied DeviceToken is Changed : \(UserDefaults.standard.string(forKey: "deviceToken"))")

                  }
              }
            
          case .notDetermined:
            print("한 번 허용 누른 경우")
          case .provisional:
            print("푸시 수신 임시 중단")
          case .ephemeral:
            // @available(iOS 14.0, *)
            print("푸시 설정이 App Clip에 대해서만 부분적으로 동의한 경우")
          @unknown default:
            print("Unknow Status")
          }
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // ✅ 알림 배너/소리/뱃지를 표시할지 결정
        completionHandler([.banner, .sound, .badge]) // 원하는 옵션만 선택 가능
    }
        
        
}
