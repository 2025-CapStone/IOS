import SwiftUI
//
//struct club_edit: View {
//    let original: Club
//    let onSave: (Club) -> Void
//
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var clubName:        String
//    @State private var location:        String
//    @State private var maxMembers:      String
//    @State private var clubDescription: String
//
//    init(club: Club, onSave: @escaping (Club) -> Void) {
//        self.original = club
//        self.onSave   = onSave
//        _clubName        = State(initialValue: club.name)
//        _location        = State(initialValue: "강서구")
//        _maxMembers      = State(initialValue: "14")
//        _clubDescription = State(initialValue: club.description)
//    }
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Image("pngwing")
//                .resizable().scaledToFit()
//                .frame(width: 115, height: 85)
//                .clipShape(Circle())
//                .shadow(radius: 5)
//                .padding(.top, 200)
//
//            VStack(spacing: 15) {
//                CustomInputField(title: "동호회 이름", text: $clubName)
//                CustomInputField(title: "지역",        text: $location)
//                CustomInputField(title: "최대 인원수", text: $maxMembers)
//                CustomInputField(title: "동호회 설명", text: $clubDescription)
//            }
//            .padding(.horizontal, 20)
//
//            Button("동호회 명부 업로드") { print("명부 업로드") }
//                .buttonStyle(OutlinedButtonStyle())
//
//            Button("저장하기") {
//                let edited = Club(
//                    id: original.id,
//                    name: clubName,
//                    description: clubDescription,
//                    logoURL: original.logoURL,
//                    backgroundURL: original.backgroundURL,
//                    createdAt: original.createdAt
//                )
//                onSave(edited)
//                dismiss()
//            }
//            .buttonStyle(FilledButtonStyle())
//            .padding(.top, 10)
//
//            Spacer()
//        }
//        .background(Color.white)
//        .edgesIgnoringSafeArea(.top)
//    }
//}
//
//struct FilledButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .font(.system(size: 20, weight: .bold))
//            .foregroundColor(.black)
//            .frame(width: 205, height: 55)
//            .background(Color.white)
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
//            .opacity(configuration.isPressed ? 0.7 : 1)
//    }
//}
//
//
// 입력 필드 ---------------------------------------------------
struct CustomInputField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 16, weight: .medium))
            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .shadow(radius: 1)
        }
    }
}




//#Preview {
//    let dto = ClubResponseDTO(
//        clubId: 99,
//        clubName: "편집 프리뷰 클럽",
//        clubDescription: "설명을 수정할 수 있어요.",
//        clubLogoURL: nil,
//        clubBackgroundURL: nil,
//        clubCreatedAt: "2025-03-08T18:20:56Z"
//    )
//    let club = Club(from: dto)
//    return club_edit(club: club) { _ in }
//}
//
//
////import SwiftUI
////
////struct club_edit: View {
////    
////    // 동호회 API
////    // 사진 업로드 할 ui 필요
////    @State private var clubName: String = ""
////    @State private var location: String = ""
////    @State private var maxMembers: String = ""
////    @State private var clubDescription: String = ""
////
////    var body: some View {
////        VStack(spacing: 20) { // 전체적인 간격 증가
////            // 상단 이미지 (pngwing 이미지)
////            Image("pngwing")
////                .resizable()
////                .scaledToFit()
////                .frame(width: 115, height: 85)
////                .clipShape(Circle())
////                .shadow(radius: 5)
////                .padding(.top, 200) // UI 전체적으로 아래로 이동
////
////            // 입력 필드
////            VStack(spacing: 15) {
////                CustomInputField(title: "동호회 이름", text: $clubName)
////                CustomInputField(title: "지역", text: $location)
////                CustomInputField(title: "최대 인원수", text: $maxMembers)
////                CustomInputField(title: "동호회 설명", text: $clubDescription)
////            }
////            .padding(.horizontal, 20)
////            
////
////            // 동호회 명부 업로드 버튼
////            //??
////            Button(action: {
////                print("동호회 명부 업로드 클릭됨")
////            }) {
////                Text("동호회 명부 업로드")
////                    .font(.system(size: 18, weight: .medium))
////                    .foregroundColor(.black)
////                    .frame(width: 296, height: 50)
////                    .background(Color.white)
////                    .cornerRadius(10)
////                    .overlay(
////                        RoundedRectangle(cornerRadius: 10)
////                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
////                    )
////            }
////
////            // 저장하기 버튼
////            Button(action: {
////                print("저장하기 버튼 클릭됨")
////            }) {
////                Text("저장하기")
////                    .font(.system(size: 20, weight: .bold))
////                    .foregroundColor(.black)
////                    .frame(width: 205, height: 55)
////                    .background(Color.white)
////                    .cornerRadius(20)
////                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
////            }
////            .padding(.top, 10)
////
////            Spacer() // 전체적으로 요소들이 아래로 이동하도록 추가
////        }
////        .background(Color.white)
////        .edgesIgnoringSafeArea(.top)
////    }
////}
////
////// ✅ 커스텀 입력 필드 (변경 없음)
////struct CustomInputField: View {
////    var title: String
////    @Binding var text: String
////
////    var body: some View {
////        VStack(alignment: .leading, spacing: 5) {
////            Text(title)
////                .font(.system(size: 16, weight: .medium))
////                .foregroundColor(.black)
////            
////            TextField("", text: $text)
////                .padding()
////                .background(Color.white)
////                .cornerRadius(10)
////                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
////                .shadow(radius: 1)
////        }
////    }
////}
////
////// 미리보기
////#Preview {
////    club_edit()
////}
