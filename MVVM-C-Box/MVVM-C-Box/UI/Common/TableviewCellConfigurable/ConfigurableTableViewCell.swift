//
//  ConfigurableTableViewCell.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 18.01.2022.
//

import Foundation
import UIKit

protocol ConfigurableTableViewCell where Self: UITableViewCell {
    func congigureCell(with configuration: BaseTableviewCellConfiguration)
}
