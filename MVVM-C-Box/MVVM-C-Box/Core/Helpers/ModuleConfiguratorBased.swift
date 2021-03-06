//
//  ModuleConfiguratorBased.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 21.01.2022.
//

import Foundation
import UIKit

protocol ModuleConfiguratorBased {
    associatedtype ModuleConfiguratorType
    var moduleConfigurator: ModuleConfiguratorType! { get set }
    func setup()
}

extension ModuleConfiguratorBased where Self: UIViewController {
    static func instantiate(with moduleConfigurator: ModuleConfiguratorType) -> Self {
        var viewController = Self.loadFromNib()
        viewController.moduleConfigurator = moduleConfigurator
        viewController.setup()
        return viewController
    }
}


protocol ViewModelBased {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
}

extension ViewModelBased where Self: UIViewController {
    static func instantiate(with viewModel: ViewModelType) -> Self {
        var viewController = Self.loadFromNib()
        viewController.viewModel = viewModel
        return viewController
    }
}
