//
//  ContentView.swift
//  capstone_2025
//
//  Created by Yoon on 2/18/25.
//


import SwiftUI

enum LaunchNumber:Int{
    case one
    case two
    case three
    case four
    case five
    
}

struct ContentView: View {
    
    @State private var isLaunch: Int = LaunchNumber.one.rawValue // ❗️변수 추가
    
    var body: some View {
        
        switch isLaunch {
        case LaunchNumber.one.rawValue :
            Loading() // ❗️만들었던 뷰
                .onAppear {
                    self.splashAdd()
                }
        case LaunchNumber.two.rawValue :
           introduce() // ❗️만들었던 뷰
                .onAppear {
                    self.splashAdd()
                }
        case LaunchNumber.three.rawValue :
            introduce_1() // ❗️만들었던 뷰
                .onAppear {
                    self.splashAdd()
                }
        case LaunchNumber.four.rawValue :
            introduce_2() // ❗️만들었던 뷰
                .onAppear {
                    self.splashAdd()
                }
            
        case LaunchNumber.four.rawValue :
            introduce_3() // ❗️만들었던 뷰
                .onAppear {
                    self.splashAdd()
                }.onDisappear(){
                    Login()
                }

        default:
            Login()
        }
        
 
        
    }
    
}

extension ContentView{
    
    func splashAdd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // ❗️1.5초
            self.isLaunch+=1
        }
    }
}

#Preview {
    ContentView()
}
