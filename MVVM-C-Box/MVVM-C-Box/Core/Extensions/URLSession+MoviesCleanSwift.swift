//
//  URLSession+MoviesCleanSwift.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 16.01.2022.
//

import Foundation

extension URLSession {
    private struct Constants {
        static let timeoutIntervalForRequest = TimeInterval(10)
    }
    
    static var base: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.timeoutIntervalForRequest
        config.timeoutIntervalForResource = Constants.timeoutIntervalForRequest
        return URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
}
