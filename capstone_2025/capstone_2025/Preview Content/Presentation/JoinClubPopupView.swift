import SwiftUI

/// 클럽 ID를 입력해 가입을 시도하는 팝업
struct JoinClubPopupView: View {
    @Binding var isVisible: Bool
    var onJoin: (String) -> Void          // 최종 가입 액션

    @State private var clubIdText = ""    // 입력한 ID
    @State private var showConfirm = false
    @State private var confirmClubName = ""   // 확인 팝업용 이름
    @State private var errorMessage = ""      // 존재하지 않을 때
    @ObservedObject var viewModel: ClubListViewModel

    var body: some View {
        ZStack {
            //------------------------------------------------------------------
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { isVisible = false }

            //------------------------------------------------------------------
            VStack(spacing: 16) {
                Image("popupHeader")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()

                Text("가입할 클럽의 ID를 입력하세요")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                TextField("클럽 ID", text: $clubIdText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding(.horizontal, 24)
                    .keyboardType(.numberPad)

                // 에러 메시지
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, -8)
                }

                HStack(spacing: 40) {
                    Button("가입")  { tryShowConfirm() }
                    Button("닫기")  { isVisible = false }
                }
                .font(.system(size: 14, weight: .semibold))
                .padding(.bottom, 12)
            }
            .frame(width: 260)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 6)

            //------------------------------------------------------------------
            // 중간 확인 팝업
            if showConfirm {
                JoinConfirmPopupView(
                    clubId: clubIdText,
                    clubName: confirmClubName,
                    isVisible: $showConfirm,
                    onConfirm: {
                        guard let clubId = Int(clubIdText) else { return }

                        viewModel.joinClub(clubId: clubId) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    isVisible = false  // 팝업 닫기
                                    showConfirm = false
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                    showConfirm = false
                                }
                            }
                        }
                    }
                )
            }
        }
    }

    // MARK: - Helpers ---------------------------------------------------------
    private func tryShowConfirm() {
        errorMessage = ""
        let trimmed = clubIdText.trimmingCharacters(in: .whitespaces)
        guard let id = Int(trimmed) else {
            errorMessage = "숫자 형태의 ID를 입력하세요."
            return
        }

        viewModel.findClubNameById(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let name):
                    confirmClubName = name
                    showConfirm = true
                case .failure:
                    errorMessage = "존재하지 않는 ID입니다."
                }
            }
        }
    }
    
    
    

}
