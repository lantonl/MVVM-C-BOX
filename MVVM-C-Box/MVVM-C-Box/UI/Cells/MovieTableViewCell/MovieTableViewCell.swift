//
//  MovieTableCell.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 18.01.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    private struct Constants {
        static let titleFontSize: CGFloat = 24
        static let descriptionFontSize: CGFloat = 16
    }
    
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearCell()
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        
        releaseDateLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        releaseDateLabel.lineBreakMode = .byTruncatingTail
        releaseDateLabel.numberOfLines = 1
        
        rateLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        rateLabel.lineBreakMode = .byTruncatingTail
        rateLabel.numberOfLines = 1
    }
    
    private func clearCell() {
        titleLabel.text = nil
        releaseDateLabel.text = nil
        rateLabel.text = nil
    }
}


extension MovieTableViewCell: ConfigurableTableViewCell {
    func congigureCell(with configuration: BaseTableviewCellConfiguration) {
        guard let movieTableViewCellConfiguration = configuration as? MovieTableViewCellConfiguration else {
            clearCell()
            return
        }
        
        titleLabel.text = movieTableViewCellConfiguration.titleLabelText
        titleLabel.isHidden = movieTableViewCellConfiguration.titleLabelHidden
        
        releaseDateLabel.text = movieTableViewCellConfiguration.releaseDateText
        releaseDateLabel.text = movieTableViewCellConfiguration.releaseDateText
        
        rateLabel.text = movieTableViewCellConfiguration.rateLabelText
        rateLabel.isHidden = movieTableViewCellConfiguration.rateLabelHidden
        
        selectionStyle = movieTableViewCellConfiguration.selectionStyle
    }
}


