//
//  MockBackend.swift
//  capstone_2025
//
//  Created by Yoon on 5/12/25.
//

import Foundation

/// 실제 서버 대신 메모리 안에서 동작하는 가짜 백엔드
final class MockBackend {
    /// 샘플 클럽 데이터 (클럽 ID → 클럽 이름)
    private var clubs: [Int: String] = [
        101: "테니스 동호회",
        202: "축구 동호회",
        303: "보드게임 동호회"
    ]
    
    /// 클럽 ID로 가입 시도 → (성공 여부, 클럽 이름)
    func joinClub(id: Int) -> (Bool, String?) {
        guard let name = clubs[id] else { return (false, nil) }
        // 실제라면 여기서 DB에 '회원-클럽' 레코드를 추가했을 것…
        return (true, name)
    }
    
    // 싱글턴
    static let shared = MockBackend()
    private init() {}
}
