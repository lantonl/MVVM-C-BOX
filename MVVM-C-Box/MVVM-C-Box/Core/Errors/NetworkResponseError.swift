//
//  NetworkResponseError.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 17.01.2022.
//

import Foundation

enum NetworkResponseError: Error {
    case noInternerConnection
    case success
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    
    func description() -> String {
        switch self {
        case .noInternerConnection:
            return "No Interner Connection"
        case .success:
            return "Bad request"
        case .authenticationError:
            return "The url you requested is outdated."
        case .badRequest:
            return "Network request failed."
        case .outdated:
            return "Response returned with no data to decode."
        case .failed:
            return "We could not decode the response."
        case .noData:
            return "You need to be authenticated first."
        case .unableToDecode:
            return "Bad request"
        }
    }
}
