//
//  NetworkingServiceBase.swift.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 16.01.2022.
//

import Foundation

typealias APICallback = (Result<Data?, Error>) -> Void
typealias URLRequestCreationResult = (request: URLRequest?, error: Error?)

protocol BaseNetworkingService {
    var baseUrl: URL! { get }
    var sessionManager: URLSessionProtocol { get }
    
    init(baseUrlString: String, sessionManager: URLSessionProtocol)
    
    func get(path: String, params: [String: String]?, headerParams: [String: String]?, result: @escaping APICallback)
}

extension BaseNetworkingService {
    func get(path: String, params: [String: String]?, headerParams: [String: String]? = nil, result: @escaping APICallback) {
        let urlRequestCreationResult = self.createGetRequest(path: path, params: params, headerParams: headerParams)
        
        if let request = urlRequestCreationResult.request {
            self.dataTask(with: request, result: result).resume()
        } else {
            result(.failure(urlRequestCreationResult.error ?? NetworkResponseError.badRequest))
        }
    }
    
    private func createGetRequest(path: String, params: [String: String]?, headerParams: [String: String]?) -> URLRequestCreationResult {
        let urlComponents = self.urlComponents(with: path)
        urlComponents.queryItems = params?.map { (key, value) -> URLQueryItem in URLQueryItem(name: key, value: value) }
        
        guard let url = urlComponents.url else {
            return (nil, NetworkResponseError.badRequest)
        }
        
        var urlRequest = URLRequest(url: url)
        headerParams?.forEach { header in urlRequest.setValue(header.value, forHTTPHeaderField: header.key) }
        
        return (urlRequest, nil)
    }
    
    private func urlComponents(with path: String) -> NSURLComponents {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = baseUrl.scheme
        urlComponents.host = baseUrl.host
        urlComponents.path = baseUrl.path + path
        
        return urlComponents
    }
    
    private func dataTask(with urlRequest: URLRequest, result: @escaping APICallback) -> URLSessionDataTask {
        return sessionManager.dataTask(with: urlRequest) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            guard error == nil else {
                result(.failure(NetworkResponseError.noInternerConnection))
                return
            }
            
            if let httpUrlResponse = urlResponse as? HTTPURLResponse {
                switch HTTPURLResponseHandler.handle(response: httpUrlResponse) {
                case .success:
                    result(.success(data))
                case .failure(let error):
                    result(.failure(error))
                }
            }
        }
    }
}
