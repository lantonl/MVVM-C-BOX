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
    func getFirstBatchOfMovies(for request: MoviesList.Movies.Request, completion: @escaping (Result<MovieAPIResponse?, Error>) -> Void)
    func getNextBatchOfMovies(for request: MoviesList.Movies.Request, completion: @escaping (Result<MovieAPIResponse?, Error>) -> Void)
}

final class MoviesNetworkingService: BaseNetworkingService, MoviesNetworkingServiceProtocol {
    private struct Constants {
        static let firstPageIndex = 1
    }
    
    var baseUrl: URL!
    var sessionManager: URLSessionProtocol
    
    private var moviesAPIResponse: MovieAPIResponse?
    
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
    
    func getFirstBatchOfMovies(for request: MoviesList.Movies.Request, completion: @escaping (Result<MovieAPIResponse?, Error>) -> Void) {
//        guard !request.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            presenter?.showEmtySearchRequestWarningMessage()
//            return
//        }
        
        getMovies(with: request.title, page: Constants.firstPageIndex) { [weak self] result in
            switch result {
            case .success(let response):
                self?.moviesAPIResponse = response
                
//                guard let moviesAPIResponse = self?.moviesAPIResponse, !moviesAPIResponse.movies.isEmpty else {
//                    self?.presenter?.showEmptySearchResultMessage()
//                    return
//                }
                
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getNextBatchOfMovies(for request: MoviesList.Movies.Request, completion: @escaping (Result<MovieAPIResponse?, Error>) -> Void) {
        guard let pageToRequest = moviesAPIResponse?.nextPage else {
            completion(.success(moviesAPIResponse))
            return
        }
        
        getMovies(with: request.title, page: pageToRequest) { [weak self] result in
            switch result {
            case .success(let response):
                self?.moviesAPIResponse = response
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
