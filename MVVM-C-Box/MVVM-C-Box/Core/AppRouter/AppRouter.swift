//
//  AppRouter.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 18.01.2022.
//

import Foundation
import UIKit

class AppRouter: ActionResponder {
    var nextActionResponder: ActionResponder?
    
    private struct Constants {
        static let moviesListViewControllerTitleText = "themoviedb.org"
    }
    
    private let navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
        showMoviesListScene()
    }
    
    private func showMoviesListScene() {
        let model = MoviesListViewModel()
        model.nextActionResponder = self
        
        let controller = MoviesListViewController.instantiate(with: model)
        controller.title = Constants.moviesListViewControllerTitleText
        navController.viewControllers = [controller]
    }
    
    func handleAction(_ action: Action) {
        guard let genericAction = action as? GenericAction else {
            return
        }
        
        switch genericAction.type {
        case .show:
            guard let destinationPage = action.userInfo[GenericActionKey.destinationPage] as? PageType, destinationPage == .movieDetails, let movie = genericAction.userInfo[GenericActionKey.nestedObject] as? Movie else {
                nextActionResponder?.handleAction(action)
                return
            }
            
            displayMovieDetails(with: movie)
        default:
            nextActionResponder?.handleAction(action)
        }
    }
    
    private func displayMovieDetails(with movie: Movie) {
        let viewController = MovieDetailsViewController.instantiate(with: MovieDetailsModuleConfigurator())
        
        navController.present(viewController, animated: true)
        
        let movieDetailsConfiguration = MovieDetailsViewControllerConfiguration(with: movie)
        viewController.displayMovieDetails(viewModel: MovieDetails.UI.ViewModel(configuration: movieDetailsConfiguration))
    }
}
