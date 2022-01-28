//
//  MovieApiResponse.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 16.01.2022.
//

import Foundation

struct MovieAPIResponse {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    let movies: [Movie]
    
    var nextPage: Int? {
        return page < numberOfPages ? page + 1 : nil
    }
}

extension MovieAPIResponse: Decodable {
    private enum MovieAPIResponseCodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieAPIResponseCodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        movies = try container.decode([Movie].self, forKey: .movies)
    }
}
