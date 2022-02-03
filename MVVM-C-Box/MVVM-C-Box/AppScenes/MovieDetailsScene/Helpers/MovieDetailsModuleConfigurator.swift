//
//  MovieDetailsModuleConfigurator.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 21.01.2022.
//

import Foundation

class MovieDetailsModuleConfigurator: ModuleConfigurator {
    typealias ViewControllerForConfigurationType = MovieDetailsViewController
    
    typealias InteractorType = MovieDetailsBusinessLogic & MovieDetailsDataStore
    typealias PresenterType = MovieDetailsPresentationLogic
    typealias RouterType = (MovieDetailsDataPassing & MovieDetailsRoutingLogic & NSObjectProtocol)
    
    var interactor: InteractorType
    var presenter: PresenterType
    var router: (MovieDetailsDataPassing & MovieDetailsRoutingLogic & NSObjectProtocol)
    
    required init(interactor: InteractorType = MovieDetailsInteractor(), presenter: PresenterType = MovieDetailsPresenter(), router: RouterType = MovieDetailsRouter()) {
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
    }
    
    func module(configure viewController: ViewControllerForConfigurationType) {
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.viewController = viewController
        router.dataStore = interactor
    }
}
