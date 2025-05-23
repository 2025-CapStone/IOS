


import SwiftUI

struct introduce: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        ZStack {
            // 배경 색상
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer() // 상단 여백
                
                // 아래 흰색 배경 부분
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white)
                        .frame(height: 400)
                        .overlay(
                            VStack(spacing: 20) {
                                // 아이콘 (동호회 아이콘)
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 80, height: 80)
                                    
                                    Image("logo 1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:150, height: 150)
                                }
                                .offset(y: -40) // 원이 살짝 올라가도록 조정
                                
                                // 제목 텍스트
                                Text("OnClub")
                                    .font(.custom("Comfortaa-Bold", size: 28)) // 원하는 폰트 적용
                                    .foregroundColor(.black)
                                
                                // 설명 텍스트
                                Text("""
                                테니스의 즐거움, 관리까지 온클럽에서
                                """)
                                .font(.system(size: 18, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(width: 250)
                            }
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                router.path.append(AppRoute.login)
            }
        }
    }
    
    //    struct ContentView_Previews: PreviewProvider {
    //        static var previews: some View {
    //            ContentView()
    //        }
    //    }
}
    #Preview{
        introduce()
    }

