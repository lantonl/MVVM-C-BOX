//
//  ModuleConfigurator.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 21.01.2022.
//

import Foundation
import UIKit

protocol ModuleConfigurator where ViewControllerForConfigurationType: UIViewController {
    associatedtype ViewControllerForConfigurationType
    associatedtype InteractorType
    associatedtype PresenterType
    associatedtype RouterType
    
    var interactor: InteractorType { get }
    var presenter: PresenterType { get }
    var router: RouterType { get }
    
    init(interactor: InteractorType, presenter: PresenterType, router: RouterType)
    
    func module(configure viewController: ViewControllerForConfigurationType)
}
