import Foundation

/// 실제 서버 대신 메모리 안에서 동작하는 가짜 백엔드
final class MockBackend {
    /// 샘플 클럽 데이터 (클럽 ID → 클럽 이름)
    private var clubs: [Int: String] = [
        101: "테니스 동호회",
        202: "축구 동호회",
        303: "보드게임 동호회"
    ]
    
    /// 클럽 ID로 ‘가입’ 시도 → (성공 여부, 클럽 이름)
    func joinClub(id: Int) -> (Bool, String?) {
        guard let name = clubs[id] else { return (false, nil) }
        return (true, name)
    }
    
    /// 클럽 ID로 이름만 조회 (가입은 아직 X)
    func clubName(id: Int) -> String? {
        clubs[id]
    }
    
    // 싱글턴
    static let shared = MockBackend()
    private init() {}
}
