//
//  LoadingTableViewCell.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 19.01.2022.
//

import Foundation
import UIKit

class LoadingTableViewCell: UITableViewCell {
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.startAnimating()
    }
}

extension LoadingTableViewCell: ConfigurableTableViewCell {
    func congigureCell(with configuration: BaseTableviewCellConfiguration) {
        self.selectionStyle = configuration.selectionStyle
    }
}
