//
//  MovieDetailsViewControllerConfiguration.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 21.01.2022.
//

import Foundation
import UIKit

struct MovieDetailsViewControllerConfiguration: Equatable {
    private struct Constnats {
        static let closeButtonTitleText = "Close"
        static let releaseDatePlaceholderText = "Relese date:"
        static let ratingPlaceholder = "Rating:"
        static let maximumFractionDigitsForRating = 2
        
        static let titleLabelFontSize: CGFloat = 30
        static let descriptionTextViewFontSize: CGFloat = 24
        static let ratingLabelFontSize: CGFloat = 30
        static let releaseDateLabelFontSize: CGFloat = 30
    }
    
    let closeButtonTitleText = Constnats.closeButtonTitleText
    
    let titleText: String
    let desriptionText: String
    let ratingText: String
    let releaseDateText: String
    
    let titleLabelFont: UIFont
    let descriptionTextViewFont: UIFont
    let ratingLabelFont: UIFont
    let releaseDateLabelFont: UIFont
    
    init(with movie: Movie) {
        self.titleText = movie.title ?? ""
        self.releaseDateText = "\(Constnats.releaseDatePlaceholderText) \(movie.releaseDate ?? "")"
        self.ratingText = "\(Constnats.ratingPlaceholder) \(movie.rating?.string(maximumFractionDigits: Constnats.maximumFractionDigitsForRating) ?? "")"
        self.desriptionText = movie.overview ?? ""
        
        self.titleLabelFont = UIFont.systemFont(ofSize: Constnats.titleLabelFontSize)
        self.descriptionTextViewFont = UIFont.systemFont(ofSize: Constnats.descriptionTextViewFontSize)
        self.ratingLabelFont = UIFont.systemFont(ofSize: Constnats.ratingLabelFontSize)
        self.releaseDateLabelFont = UIFont.systemFont(ofSize: Constnats.releaseDateLabelFontSize)
    }
}
