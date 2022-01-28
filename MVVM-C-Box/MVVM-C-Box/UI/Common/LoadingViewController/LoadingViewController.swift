//
//  LoadingViewController.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 17.01.2022.
//

import Foundation
import UIKit

class LoadingViewController: BaseViewController {
    private struct Constants {
        static let activityIndicatorColor = UIColor.black
    }

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = Constants.activityIndicatorColor
        activityIndicator.startAnimating()
    }
}
