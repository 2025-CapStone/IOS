import SwiftUI

struct FilterPopupView: View {
    @Binding var isVisible: Bool // ✅ 팝업 상태 제어
    @State private var selectedRole: String? = nil // ✅ 선택된 버튼을 저장하는 상태 변수
    @State private var showConfirmation = false // ✅ 선택 확인창 표시 여부
    @Binding var userRole: String // ✅ 선택한 역할을 `club_intro`로 전달

    var body: some View {
        ZStack {
            // 🔹 반투명 배경 (클릭하면 팝업 닫힘)
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isVisible = false
                    }
                }
            
            // 🔹 팝업 창
            VStack(spacing: 20) {
                // 🔹 상단 닫기 버튼 (위치 조정하여 X 버튼이 잘리지 않도록)
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isVisible = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle()) // ✅ 동그랗게 만들어서 더 깔끔하게
                            .shadow(radius: 2)
                    }
                }
                .padding(.trailing, 15) // ✅ X 버튼이 잘리지 않도록 우측 여백 추가
                .padding(.top, 40) // ✅ X 버튼을 조금 더 아래로 이동

                // 🔹 동호회 대표 이미지
                Image("image") // ✅ 업로드한 이미지 사용
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // 🔹 동호회 이름
                Text("동호회 이름")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // 🔹 아이콘 및 회원 정보
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)

                // 🔹 필터 버튼 목록 (사용자가 선택 가능)
                VStack(spacing: 15) { // ✅ 버튼 간격 증가 (10 → 15)
                    SelectableButton(title: "일반 회원", selectedRole: $selectedRole, showConfirmation: $showConfirmation)
                    SelectableButton(title: "운영진", selectedRole: $selectedRole, showConfirmation: $showConfirmation)
                }
                .padding(.horizontal)

                Spacer().frame(height: 10) // ✅ 추가 여유 공간 확보
            }
            .padding()
            .frame(width: 280, height: 420) // ✅ 팝업 높이 증가 (400 → 420)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)

            // ✅ 선택 확인 창 (선택 시 표시)
            if showConfirmation {
                ConfirmationPopup(
                    selectedRole: selectedRole ?? "",
                    isVisible: $showConfirmation,
                    userRole: $userRole, // ✅ 선택한 역할을 club_intro로 전달
                    closePopup: { isVisible = false } // ✅ 팝업 닫기
                )
            }
        }
    }
}

// ✅ 버튼 스타일 (선택 가능하도록 수정)
struct SelectableButton: View {
    var title: String
    @Binding var selectedRole: String?
    @Binding var showConfirmation: Bool // ✅ 선택 확인 창 표시 여부

    var body: some View {
        Button(action: {
            selectedRole = title
            showConfirmation = true // ✅ 선택하면 확인 창 띄우기
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// ✅ 선택 확인 팝업 (예/아니오 버튼 추가)
struct ConfirmationPopup: View {
    var selectedRole: String
    @Binding var isVisible: Bool // ✅ 확인 창 표시 여부
    @Binding var userRole: String // ✅ 선택한 역할 저장
    var closePopup: () -> Void // ✅ 팝업을 닫는 함수

    var body: some View {
        VStack(spacing: 20) {
            Text("\(selectedRole)을 선택하시겠습니까?")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            HStack {
                Button(action: {
                    closePopup() // ✅ 팝업만 닫기
                }) {
                    Text("아니오")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    print("\(selectedRole) 선택됨") // ✅ 실제 적용 로직 추가 가능
                    userRole = selectedRole // ✅ 선택한 역할 저장
                    closePopup() // ✅ 팝업 닫기
                }) {
                    Text("예")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
