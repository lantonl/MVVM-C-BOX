//
//  NetworkingServiceMovies.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 16.01.2022.
//

import Foundation

private struct MoviesAPIPath {
    static let search = "3/search/movie"
}

private struct MoviesAPIParametersKey {
    static let apiKey = "api_key"
    static let search = "query"
    static let page = "page"
}

private enum MoviesAPIRequestParameters {
    case search(title: String, page: Int)
    
    func parameters() -> [String : String] {
        switch self {
        case .search(let title, let page):
            return [MoviesAPIParametersKey.search: title,
                    MoviesAPIParametersKey.apiKey: MoviesAPIConfiguration.baseAPIKey,
                    MoviesAPIParametersKey.page : "\(page)"]
        }
    }
}

protocol MoviesNetworkingServiceProtocol {
    func getMovies(with title: String, page: Int, completion: @escaping (Result<MovieAPIResponse?, Error>) -> Void)
}

struct MoviesNetworkingService: BaseNetworkingService, MoviesNetworkingServiceProtocol {
    private struct Constants {
        static let firstPageIndex = 1
    }
    
    var baseUrl: URL!
    var sessionManager: URLSessionProtocol
    
    init(baseUrlString: String = MoviesAPIConfiguration.baseURL, sessionManager: URLSessionProtocol = URLSession.base) {
        guard let baseUrl = URL(string: baseUrlString) else {
            fatalError("baseURL could not be configured.")
        }
        
        self.baseUrl = baseUrl
        self.sessionManager = sessionManager
    }
    
    func getMovies(with title: String, page: Int = Constants.firstPageIndex, completion: @escaping (Result<MovieAPIResponse?, Error>) -> Void) {
        get(path: MoviesAPIPath.search, params: MoviesAPIRequestParameters.search(title: title, page: page).parameters()) { result in
            switch result {
            case .success(let data):
                do {
                    guard let data = data else {
                        completion(.success(nil))
                        return
                    }
                    
                    let apiResponse = try JSONDecoder().decode(MovieAPIResponse.self, from: data)
                    completion(.success(apiResponse))
                } catch {
                    completion(.failure(NetworkResponseError.unableToDecode))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
