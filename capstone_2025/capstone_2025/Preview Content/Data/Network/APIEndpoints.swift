//import Foundation
//
// MARK: - API Endpoint 구성
struct APIEndpoints {
//    
//    static func getMovies(with moviesRequestDTO: MoviesRequestDTO) -> Endpoint<MoviesResponseDTO> {
//
//        return Endpoint(
//            path: "3/search/movie",
//            method: .get,
//            queryParametersEncodable: moviesRequestDTO
//        )
//    }
//
//    static func getMoviePoster(path: String, width: Int) -> Endpoint<Data> {
//
//        let sizes = [92, 154, 185, 342, 500, 780]
//        let closestWidth = sizes
//            .enumerated()
//            .min { abs($0.1 - width) < abs($1.1 - width) }?
//            .element ?? sizes.first!
//        
//        return Endpoint(
//            path: "t/p/w\(closestWidth)\(path)",
//            method: .get,
//            responseDecoder: RawDataResponseDecoder()
//        )
//    }
    
    
    static func signup(_ dto: SignUpRequestDTO) -> Endpoint<SignUpResponseDTO> {
        Endpoint(
            path: "api/user/join",
            method: .post,
            bodyParametersEncodable: dto,
            bodyEncoder: JSONBodyEncoder(),
            responseDecoder: JSONResponseDecoder()
        )
    }

    static func login(_ dto: LoginRequestDTO) -> Endpoint<LoginResponseDTO> {
        Endpoint(
            path: "api/user/login",
            method: .post,
            bodyParametersEncodable: dto,
            bodyEncoder: JSONBodyEncoder(),
            responseDecoder: JSONResponseDecoder()
        )
    }

    static func refreshToken(_ token: String) -> Endpoint<LoginResponseDTO> {
        Endpoint(
            path: "api/user/refresh",
            method: .post,
            headerParameters: ["Authorization": "Bearer \(token)"],
            responseDecoder: JSONResponseDecoder()
        )
    }
    
    static func logout(_ token: String) -> Endpoint<Void> {
        Endpoint(
            path: "api/user/logout",
            method: .post,
            headerParameters: [
                "Authorization": token, // Bearer 없이
                "Content-Type": "application/json"
            ],
            responseDecoder: JSONResponseDecoder()
        )
    }


    
}
