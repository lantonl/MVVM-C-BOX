//
//  MoviesListViewModel.swift
//  MVVM-C-Box
//
//  Created by Anton Gutkin on 28.01.2022.
//

import Foundation

enum MoviesListViewModelFetchType {
    case initial
    case firstPage(request: MoviesList.Movies.Request)
    case nextPage(request: MoviesList.Movies.Request)
}

class MoviesListViewModel: ActionResponder {
    weak var nextActionResponder: ActionResponder?
    
    var cellConfigurations = [MoviesList.UI.CellConfiguration]()
    
    let isLoading = Box(false)
    let error: Box<Error?> = Box(nil)
    let message: Box<MoviesList.UI.Message?> = Box(nil)
    
    var request: MoviesList.Movies.Request? = nil
    
    private let service: MoviesNetworkingServiceProtocol
    private let cellConfigurationsFactory: MoviesListCellConfigurationsFactory
    
    init(with service: MoviesNetworkingServiceProtocol = MoviesNetworkingService(), cellConfigurationsFactory: MoviesListCellConfigurationsFactory = MoviesListCellConfigurationsFactoryBase()) {
        self.service = service
        self.cellConfigurationsFactory = cellConfigurationsFactory
    }
    
    func fetchData(type: MoviesListViewModelFetchType) {
        switch type {
        case .initial:
            message.value = initialMessage()
        case .firstPage(let request):
            guard !request.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                message.value = emtySearchRequestWarningMessage()
                return
            }
            
            isLoading.value = true
            
            service.getFirstBatchOfMovies(for: request) { [weak self] result in
                self?.handleInitialFetchResult(result)
            }
        case .nextPage(let request):
            service.getNextBatchOfMovies(for: request) { [weak self] result in
                self?.handlenextPageFetchResult(result)
            }
        }
    }
    
    func handleMovieSelection(for index: Int) {
        guard cellConfigurations.count > index, let movie = (cellConfigurations[index].configuration as? MovieTableViewCellConfiguration)?.movie else {
            return
        }
        
        nextActionResponder?.handleAction(GenericAction(.show(presentationStyle: .fullScreen), nil, [GenericActionKey.destinationPage: PageType.movieDetails, GenericActionKey.nestedObject: movie]))
    }
}

private extension MoviesListViewModel {
    private func handleInitialFetchResult(_ result: Result<MovieAPIResponse?, Error>) {
        switch result {
        case .success(let response):
            if let response = response, !response.movies.isEmpty {
                cellConfigurations = cellConfigurationsFactory.generateCellCongigurations(for: response)
                isLoading.value = false
            } else {
                cellConfigurations = [MoviesList.UI.CellConfiguration]()
                isLoading.value = false
                message.value = emptySearchResultMessage()
            }
        case .failure(let error):
            isLoading.value = false
            self.error.value = error
        }
    }
    
    private func handlenextPageFetchResult(_ result: Result<MovieAPIResponse?, Error>) {
        switch result {
        case .success(let response):
            if let response = response {
                cellConfigurations = cellConfigurationsFactory.generateCellCongigurationsWithNextPage(for: response)
                isLoading.value = false
            } else {
                cellConfigurations = [MoviesList.UI.CellConfiguration]()
                isLoading.value = false
                message.value = emptySearchResultMessage()
            }
        case .failure(let error):
            isLoading.value = false
            self.error.value = error
        }
    }
    
    private func initialMessage() -> MoviesList.UI.Message {
        let message = MoviesList.UI.Message(title: Constants.initialMessageTitle, description: Constants.initialMessageDescription)
        return message
    }
    
    private func emtySearchRequestWarningMessage() -> MoviesList.UI.Message {
        let message = MoviesList.UI.Message(title: Constants.defaultWarningMessageTitle, description: Constants.emtySearchRequestWarningMessageDescription)
        return message
    }
    
    private func emptySearchResultMessage() -> MoviesList.UI.Message {
        let message = MoviesList.UI.Message(title: Constants.defaultWarningMessageTitle, description: Constants.emptySearchResultWarningMessageDescription)
        return message
    }
}

private struct Constants {
    static let defaultWarningMessageTitle = "Something went wrong"
    static let emtySearchRequestWarningMessageDescription = "We can not search films without name. Please type something"
    static let emptySearchResultWarningMessageDescription = "We could not find any movies =("
    
    static let initialMessageTitle = "Hello!"
    static let initialMessageDescription = "We can find any film you search. Just type something in search field! =)"
}
