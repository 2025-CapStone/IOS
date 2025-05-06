import SwiftUI

// ✅ home.swift 수정본 (NavigationView 제거 + club_intro 개선)

struct home: View {
    @StateObject private var viewModel = ClubListViewModel()
    @State private var searchText = ""
    @State private var isFilterPopupVisible = false
    @State private var isLogoutAlertVisible = false

    @EnvironmentObject var router: NavigationRouter

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)

    private var clubs: [Club] {
        viewModel.clubs.map(Club.init(from:))
    }

    private var filteredClubs: [Club] {
        let key = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return key.isEmpty ? clubs : clubs.filter { $0.name.localizedCaseInsensitiveContains(key) }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header

                if viewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red).padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredClubs) { club in
                                NavigationLink(destination:
                                    club_intro(
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

            if isLogoutAlertVisible {
                CustomAlertView(
                    title: "로그아웃",
                    message: "로그아웃 하시겠습니까?",
                    onConfirm: {
                        isLogoutAlertVisible = false
                        router.path = NavigationPath()
                    },
                    onCancel: {
                        isLogoutAlertVisible = false
                    }
                ).zIndex(1)
            }

            if isFilterPopupVisible {
                FilterPopupView(isVisible: $isFilterPopupVisible, userRole: .constant(""))
            }
        }
    }

    private var header: some View {
        VStack(spacing: 14) {
            HStack {
                Image("ball").resizable().frame(width: 32, height: 32).onTapGesture {
                    isLogoutAlertVisible = true
                }
                Text("OnClub").font(.custom("Comfortaa-Bold", size: 24))
                Spacer()
                NavigationLink(destination: club_create()) {
                    Image(systemName: "plus").resizable().frame(width: 26, height: 26).foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("동호회 이름 검색", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 10)
                .frame(height: 42)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                .shadow(radius: 1)

                Button { isFilterPopupVisible.toggle() } label: {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .resizable().frame(width: 34, height: 34)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func clubCard(for c: Club) -> some View {
        VStack {
            clubLogo(for: c).frame(height: 120)
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
                case .failure(_):
                    AnyView(Image("defaultLogo").resizable().scaledToFill())
                @unknown default:
                    AnyView(Image("defaultLogo").resizable().scaledToFill())
                }
            }
        } else {
            Image("defaultLogo").resizable().scaledToFill()
        }
    }
}
