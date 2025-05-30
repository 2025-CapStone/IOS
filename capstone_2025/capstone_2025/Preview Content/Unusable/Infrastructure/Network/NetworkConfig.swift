import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String: String]
    let queryParameters: [String: String]
    
     init(
        baseURL: URL,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:]
     ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}

struct AuthorizedNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    var headers: [String: String] {
        var baseHeaders: [String: String] = ["Content-Type": "application/json"]
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            baseHeaders["Authorization"] = "Bearer \(token)"
        }
        return baseHeaders
    }
    let queryParameters: [String: String] = [:]
}
