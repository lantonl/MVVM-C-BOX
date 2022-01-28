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
    
    init(title: String?, releaseDate: String?, rate: Double?) {
        self.titleLabelText = title
        self.titleLabelHidden = title == nil ? true : false
        
        self.releaseDateText = "\(Constnats.releaseDatePlaceholderText) \(releaseDate ?? "")"
        self.releaseDateHidden = releaseDate == nil ? true : false
        
        
        
        self.rateLabelText = "\(Constnats.ratingPlaceholder) \(rate?.string(maximumFractionDigits: Constnats.maximumFractionDigitsForRating) ?? "")"
        self.rateLabelHidden = rate == nil ? true : false
    }
}
