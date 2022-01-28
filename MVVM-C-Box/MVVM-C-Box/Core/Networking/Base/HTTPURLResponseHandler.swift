//
//  HTTPURLResponseHandler.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 17.01.2022.
//

import Foundation

enum HTTPURLResponseHandlerResult<NetworkResponseError>{
    case success
    case failure(NetworkResponseError)
}

struct HTTPURLResponseHandler {
    static func handle(response: HTTPURLResponse) -> HTTPURLResponseHandlerResult<NetworkResponseError> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponseError.authenticationError)
        case 501...599:
            return .failure(NetworkResponseError.badRequest)
        case 600:
            return .failure(NetworkResponseError.outdated)
        default:
            return .failure(NetworkResponseError.failed)
        }
    }
}


