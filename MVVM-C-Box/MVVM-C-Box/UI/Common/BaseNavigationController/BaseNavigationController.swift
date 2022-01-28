//
//  BaseNavigationController.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 17.01.2022.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    private struct Constants {
        static let fontSize:CGFloat = 24
        static let backgroundColor = UIColor.white
        static let fontColor = UIColor.black
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .white
    }
    
    private func setup() {
        let font = UIFont.systemFont(ofSize: Constants.fontSize)
        
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: Constants.fontColor,
            .font: font
        ]
        
        self.navigationBar.prefersLargeTitles = false
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .black
        self.navigationBar.tintColor = Constants.fontColor
        self.navigationBar.titleTextAttributes = textAttributes

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = Constants.backgroundColor
        navBarAppearance.largeTitleTextAttributes = textAttributes
        navBarAppearance.titleTextAttributes = textAttributes

        self.navigationBar.standardAppearance = navBarAppearance
        self.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
