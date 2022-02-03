//
//  MovieTableViewCellConfiguration.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 18.01.2022.
//

import Foundation
import UIKit

struct MovieTableViewCellConfiguration: BaseTableviewCellConfiguration {
    private struct Constnats {
        static let releaseDatePlaceholderText = "Relese date:"
        static let ratingPlaceholder = "Rating:"
        static let maximumFractionDigitsForRating = 2
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle = .none
    
    let titleLabelText: String?
    let releaseDateText: String?
    let rateLabelText: String?
    
    let titleLabelHidden: Bool
    let releaseDateHidden: Bool
    let rateLabelHidden: Bool
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        
        self.titleLabelText = movie.title
        self.titleLabelHidden = movie.title == nil ? true : false
        
        self.releaseDateText = "\(Constnats.releaseDatePlaceholderText) \(movie.releaseDate ?? "")"
        self.releaseDateHidden = movie.releaseDate == nil ? true : false
        
        
        
        self.rateLabelText = "\(Constnats.ratingPlaceholder) \(movie.rating?.string(maximumFractionDigits: Constnats.maximumFractionDigitsForRating) ?? "")"
        self.rateLabelHidden = movie.rating == nil ? true : false
    }
}
