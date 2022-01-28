//
//  Double+MoviesCleanSwift.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 19.01.2022.
//

import Foundation

extension Double {
    func string(maximumFractionDigits: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        
        let formatedRating = formatter.string(from: NSNumber(value: self))
        return formatedRating
    }
}
