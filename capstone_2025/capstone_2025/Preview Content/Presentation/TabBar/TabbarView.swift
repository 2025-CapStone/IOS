////
////  TabbarView.swift
////  capstone_2025
////
////  Created by ㅇㅇ ㅇ on 5/22/25.
////
//
////
////import SwiftUI
////
////struct TabbarView: View {
////    
////    @State var selectedTab: Tab = .calendar
////    
////    var body: some View {
////        
////        VStack(spacing: 0) {
////            switch selectedTab {
////
////            case .calendar: break
//////                MainCalendarView(viewModel: AppDIContainer.shared.makeEventListViewModel())
//////                    .environmentObject(router)
////            case .Notification:
////                NotificationView()
////            }
////            CustomTabView(selectedTab: $selectedTab)
////                .padding(.bottom, 15)
////        }
////        .edgesIgnoringSafeArea(.bottom)
////
////    }
////}
//
//
//
//
//enum Tab {
//    case calendar
//    case Notification
//}
//
//struct CustomTabView: View {
//    
//    @Binding var selectedTab: Tab
//
//    var body: some View {
//        HStack(alignment: .center) {
//    
//            Button {
//                selectedTab = .calendar
//            } label: {
//                VStack(spacing: 8) {
//                    Image(selectedTab == .calendar ? "calendarSelected" : "calendarUnSelected")
//                    
//                    Text("캘린더")
////                        .foregroundColor(selectedTab == .calendar ? .Custom.PositiveYellow : .Custom.Black60)
////                        .font(CustomFont.PretendardSemiBold(size: 14).font)
//                }
//                .offset(x: -5)
//            }
//            .padding(.horizontal, UIScreen.main.bounds.width/4 - 30)
//            
//           
//            
//            Button {
//                selectedTab = .Notification
//            } label: {
//                VStack(spacing: 8) {
//                    Image(selectedTab == .Notification ? "NotificationSelected" : "NotificationUnSelected")
//                    
//                    Text("알림")
////                        .foregroundColor(selectedTab == .Notification ? .Custom.PositiveYellow : .Custom.Black60)
////                        .font(CustomFont.PretendardSemiBold(size: 14).font)
//                }
//                .offset(x: 5)
//            }
//            .padding(.horizontal, UIScreen.main.bounds.width/4 - 30)
//        }
//        .frame(width: UIScreen.main.bounds.width, height: 85)
//    }
//}
