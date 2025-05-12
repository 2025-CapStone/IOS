//
//  home.swift
//  OnClub
//
//  Created by ChatGPT on 2025-05-12.
//

import SwiftUI

struct home: View {
    // MARK: - View Models -----------------------------------------------------
    @StateObject private var viewModel       = ClubListViewModel()
    @StateObject private var loginViewModel  = LoginViewModel()
    @EnvironmentObject   var router          : NavigationRouter

    // MARK: - UI State --------------------------------------------------------
    @State private var searchText            = ""
    @State private var isLogoutAlertVisible  = false
    @State private var showJoinPopup         = false        // + 버튼용 팝업

    // MARK: - Layout Helpers --------------------------------------------------
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)

    // MARK: - Derived Data ----------------------------------------------------
    private var clubs: [Club] {
        viewModel.clubs.map(Club.init(from:))
    }

    private var filteredClubs: [Club] {
        let key = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return key.isEmpty ? clubs
                           : clubs.filter { $0.name.localizedCaseInsensitiveContains(key) }
    }

    // MARK: - Body ------------------------------------------------------------
    var body: some View {
        ZStack {
            // 메인 콘텐츠
            VStack(spacing: 0) {
                header

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredClubs) { club in
                                NavigationLink(
                                    destination: club_intro(
                                        club: club,
                                        onUpdate: { updated in
                                            if let i = viewModel.clubs.firstIndex(where: { $0.clubId == updated.id }) {
                                                viewModel.clubs[i] = ClubResponseDTO(
                                                    clubId: updated.id,
                                                    clubName: updated.name,
                                                    clubDescription: updated.description,
                                                    clubLogoURL: updated.logoURL,
                                                    clubBackgroundURL: updated.backgroundURL,
                                                    clubCreatedAt: ISO8601DateFormatter().string(from: updated.createdAt)
                                                )
                                            }
                                        }
                                    )
                                ) {
                                    clubCard(for: club)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
            .onAppear { viewModel.fetchClubs() }

            // + 버튼 팝업 (클럽 ID 입력 → 참가)
            if showJoinPopup {
                JoinClubPopupView(isVisible: $showJoinPopup) { clubId in
                    joinClub(with: clubId)
                }
            }
        }
        .alert(isPresented: $isLogoutAlertVisible) {
            Alert(
                title: Text("로그아웃"),
                message: Text("정말 로그아웃 하시겠습니까?"),
                primaryButton: .destructive(Text("로그아웃")) { handleLogout() },
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: - Header ----------------------------------------------------------
    private var header: some View {
        VStack(spacing: 14) {
            // 상단 바 ----------------------------------------------------------
            HStack {
                Image("ball")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture { isLogoutAlertVisible = true }

                Text("OnClub")
                    .font(.custom("Comfortaa-Bold", size: 24))

                Spacer()

                Button(action: { isLogoutAlertVisible = true }) {
                    Text("로그아웃")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // 검색창 + +버튼 ----------------------------------------------------
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("동호회 이름 검색", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 10)
                .frame(height: 42)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                .shadow(radius: 1)

                Button { showJoinPopup = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 34, height: 34)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Club Card --------------------------------------------------------
    private func clubCard(for c: Club) -> some View {
        VStack {
            clubLogo(for: c)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 15))

            Text(c.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(width: 170, height: 180)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 2)
    }

    @ViewBuilder
    private func clubLogo(for c: Club) -> some View {
        if let url = c.logoURL.flatMap(URL.init) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    AnyView(ProgressView())
                case .success(let img):
                    AnyView(img.resizable().scaledToFill())
                case .failure:
                    AnyView(Image("defaultLogo").resizable().scaledToFill())
                @unknown default:
                    AnyView(Image("defaultLogo").resizable().scaledToFill())
                }
            }
        } else {
            Image("defaultLogo")
                .resizable()
                .scaledToFill()
        }
    }

    // MARK: - Join / Logout ----------------------------------------------------
    private func joinClub(with clubId: String) {
        // TODO: 백엔드 API 호출 → 참가여부 확인 / 오류 처리
        print("참가 요청할 클럽 ID:", clubId)

        // 임시 처리: 팝업 닫고 새로고침
        showJoinPopup = false
        viewModel.fetchClubs()
    }

    private func handleLogout() {
        loginViewModel.logout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            router.path = NavigationPath()
            router.path.append(AppRoute.onboarding)
        }
    }
}
