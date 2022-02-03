//
//  MoviesListCellFactory.swift
//  MVVM-C-Box
//
//  Created by Anton Gutkin on 01.02.2022.
//

import Foundation

protocol MoviesListCellConfigurationsFactory {
    var movieTableviewCellConfigurations: [MoviesList.UI.CellConfiguration] { get }
    
    func generateCellCongigurations(for moviesResponse: MovieAPIResponse) -> [MoviesList.UI.CellConfiguration]
    func generateCellCongigurationsWithNextPage(for moviesResponse: MovieAPIResponse) -> [MoviesList.UI.CellConfiguration]
}

class MoviesListCellConfigurationsFactoryBase: MoviesListCellConfigurationsFactory {
    var movieTableviewCellConfigurations = [MoviesList.UI.CellConfiguration]()
    
    func generateCellCongigurations(for moviesResponse: MovieAPIResponse) -> [MoviesList.UI.CellConfiguration] {
        var newMovieTableviewCellConfigurations = generateCellCongigurations(with: moviesResponse.movies)
        
        if moviesResponse.nextPage != nil {
            let loadingCellConfiguration = (MoviesList.UI.CellType.loading, LoadingTableViewCellConfiguration())
            newMovieTableviewCellConfigurations.append(loadingCellConfiguration)
        }
        
        movieTableviewCellConfigurations = newMovieTableviewCellConfigurations
        
        return movieTableviewCellConfigurations
    }
    
    func generateCellCongigurationsWithNextPage(for moviesResponse: MovieAPIResponse) -> [MoviesList.UI.CellConfiguration] {
        if let loadingCellIndex = movieTableviewCellConfigurations.firstIndex(where: { $0.cellType == .loading }) {
            movieTableviewCellConfigurations.remove(at: loadingCellIndex)
        }
        
        var newMovieTableviewCellConfigurations = movieTableviewCellConfigurations + generateCellCongigurations(with: moviesResponse.movies)
        
        if moviesResponse.nextPage != nil {
            let loadingCellConfiguration = (MoviesList.UI.CellType.loading, LoadingTableViewCellConfiguration())
            newMovieTableviewCellConfigurations.append(loadingCellConfiguration)
        }
        
        movieTableviewCellConfigurations = newMovieTableviewCellConfigurations
        
        return movieTableviewCellConfigurations
    }
    
    private func generateCellCongigurations(with movies: [Movie]) -> [MoviesList.UI.CellConfiguration] {
        var newMovieTableviewCellConfigurations = [MoviesList.UI.CellConfiguration]()
        
        for movie in movies {
            let movieTableviewCellConfiguration = MovieTableViewCellConfiguration(movie: movie)
            let cellConfiguration = (MoviesList.UI.CellType.movie, movieTableviewCellConfiguration)
            newMovieTableviewCellConfigurations.append(cellConfiguration)
        }
        
        return newMovieTableviewCellConfigurations
    }
}
