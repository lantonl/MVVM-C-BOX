//
//  Movie.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 16.01.2022.
//

import Foundation

struct Movie {
    let id: Int?
    let posterPath: String?
    let backdrop: String?
    let title: String?
    let releaseDate: String?
    let rating: Double?
    let overview: String?
}

extension Movie: Decodable {
    enum MovieCodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case backdrop = "backdrop_path"
        case title
        case releaseDate = "release_date"
        case rating = "vote_average"
        case overview
    }
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        id = try movieContainer.decodeIfPresent(Int.self, forKey: .id)
        posterPath = try movieContainer.decodeIfPresent(String.self, forKey: .posterPath)
        backdrop = try movieContainer.decodeIfPresent(String.self, forKey: .backdrop)
        title = try movieContainer.decodeIfPresent(String.self, forKey: .title)
        releaseDate = try movieContainer.decodeIfPresent(String.self, forKey: .releaseDate)
        rating = try movieContainer.decodeIfPresent(Double.self, forKey: .rating)
        overview = try movieContainer.decodeIfPresent(String.self, forKey: .overview)
    }
}
