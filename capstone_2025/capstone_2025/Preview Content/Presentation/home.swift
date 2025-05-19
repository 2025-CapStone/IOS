//
//  home.swift
//  OnClub
//

import SwiftUI

struct home: View {
    // MARK: - ViewModels & Router --------------------------------------------
    @ObservedObject private var viewModel      = ClubListViewModel()
    @ObservedObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject   var router         : NavigationRouter

    @State private var isTagSearchMode: Bool = false

    // MARK: - UI State --------------------------------------------------------
    @State private var searchText           = ""
    @State private var isLogoutAlertVisible = false


    @State private var showJoinError        = false          // 가입 실패 Alert
    @State private var errorMessage         = ""             // 실패 문구
    

    
    @State private var showOnlyJoinedClubs: Bool = false
    @State private var isMenuListClicked = false
    // MARK: - Grid Layout -----------------------------------------------------
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    // MARK: - Derived Data ----------------------------------------------------
    private var clubs: [Club] {
        let source: [ClubResponseDTO] = showOnlyJoinedClubs
            ? AppState.shared.user?.joinedClub ?? []
            : viewModel.clubs

        return source.map(Club.init(from:))
    }
    
    
//    private var filteredClubs: [Club] {
//        let key = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
//        return key.isEmpty ? clubs
//                           : clubs.filter { $0.name.localizedCaseInsensitiveContains(key) }
//    }
    private var filteredClubs: [Club] {
        let key = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else { return clubs }

        if isTagSearchMode {
            return clubs.filter { club in
                club.tag.contains(where: { $0.localizedCaseInsensitiveContains(key) })
            }
        } else {
            return clubs.filter { $0.name.localizedCaseInsensitiveContains(key) }
        }
    }
    private var menuListText: String {
        showOnlyJoinedClubs ? "전체 클럽을 보시겠습니까?" : "가입된 클럽만 보시나요?"
    }

    // MARK: - Body ------------------------------------------------------------
    var body: some View {
        ZStack {
            // ───────────────── 메인 콘텐츠 ─────────────────
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
                                let destinationView = club_intro(
                                    viewModel: viewModel,
                                    club: club
                                ) { updated in
                                    if let i = viewModel.clubs.firstIndex(where: { $0.clubId == updated.id }) {
                                        viewModel.clubs[i] = ClubResponseDTO(
                                            clubId: updated.id,
                                            clubName: updated.name,
                                            clubDescription: updated.description,
                                            clubLogoURL: updated.logoURL,
                                            clubBackgroundURL: updated.backgroundURL,
                                            clubCreatedAt: ISO8601DateFormatter().string(from: updated.createdAt),
                                            tag:  ["Demo","test"]

                                        )
                                    }
                                }

                                NavigationLink(destination: destinationView) {
                                    clubCard(for: club)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
            .onAppear {
                if(showOnlyJoinedClubs){
                }
                else{
                    viewModel.fetchAllClubs()
                    viewModel.fetchClubs()}
            }

        }
        // ──────────────── Alert 들 ────────────────
        .alert("로그아웃",
               isPresented: $isLogoutAlertVisible,
               actions: {
                   Button("취소", role: .cancel) {}
                   Button("로그아웃", role: .destructive) { handleLogout() }
               },
               message: { Text("정말 로그아웃 하시겠습니까?") })
        .alert(menuListText, isPresented: $isMenuListClicked) {
            Button("예", role: .none) {
                if(showOnlyJoinedClubs){
                    
                    showOnlyJoinedClubs = false
                }else{
                    showOnlyJoinedClubs = true
                   }
            }
            Button("아니오", role: .cancel) {}
        }

    }

    // MARK: - Header ----------------------------------------------------------
    private var header: some View {
        VStack(spacing: 14) {
            // 상단 바
            HStack {
                Image("ball")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture { isLogoutAlertVisible = true }

                Text("OnClub")
                    .font(.custom("Comfortaa-Bold", size: 24))

                Spacer()

                Button("로그아웃") { isLogoutAlertVisible = true }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            HStack(spacing: 12) {
                HStack {
                    Button(action: {
                        isTagSearchMode.toggle()
                    }) {
                        Image(systemName: isTagSearchMode ? "tag.fill" : "magnifyingglass")
                            .foregroundColor(.gray)
                    }

                    TextField(isTagSearchMode ? "태그 검색" : "동호회 이름 검색", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 10)
                .frame(height: 42)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                .shadow(radius: 1)

                Button {
                    isMenuListClicked.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 34, height: 34)
                        .foregroundColor(.black).opacity(0.6)
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
                case .empty:    AnyView(ProgressView())
                case .success(let img):
                                AnyView(img.resizable().scaledToFill())
                default:        AnyView(Image("defaultLogo").resizable().scaledToFill())
                }
            }
        } else {
            Image("defaultLogo")
                .resizable()
                .scaledToFill()
        }
    }




    private func handleLogout() {
        loginViewModel.logout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            router.path = NavigationPath()
            router.path.append(AppRoute.onboarding)
        }
    }
}
#Preview {
    let dummyViewModel = ClubListViewModel()
    dummyViewModel.clubs = [
        ClubResponseDTO(
            clubId: 1,
            clubName: "테스트 클럽 1",
            clubDescription: "이것은 테스트 클럽입니다.",
            clubLogoURL: nil,
            clubBackgroundURL: nil,
            clubCreatedAt: "2025-05-18T12:00:00Z",
            tag:  ["Demo","test"]

        ),
        ClubResponseDTO(
            clubId: 2,
            clubName: "테스트 클럽 2",
            clubDescription: "두 번째 클럽입니다.",
            clubLogoURL: nil,
            clubBackgroundURL: nil,
            clubCreatedAt: "2025-05-10T15:30:00Z",
            tag:  ["Demo","test"]

        )
    ]

    return home()
        .environmentObject(NavigationRouter())
}
