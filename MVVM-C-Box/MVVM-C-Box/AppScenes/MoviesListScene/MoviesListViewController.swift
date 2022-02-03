//
//  MoviesListViewController.swift
//  MoviesCleanSwift
//
//  Created by Anton Gutkin on 18.01.2022.
//

import UIKit

class MoviesListViewController: BaseViewController, ViewModelBased {
    private struct Constants {
        static let searchBarPlaceholderText = "Search Films"
        static let backgroundColor = UIColor.white
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: MoviesListViewModel!
    private var titleForSearching = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        bind()
        
        viewModel.fetchData(type: .initial)
        
        view.backgroundColor = Constants.backgroundColor
        tableView.backgroundColor = Constants.backgroundColor
    }
    
    func selectedRow() -> Int? {
        return tableView.indexPathForSelectedRow?.row
    }
    
    private func requestFirstPageForMovies(with title: String) {
        titleForSearching = title
        let request = MoviesList.Movies.Request(title: title)
        viewModel.fetchData(type: .firstPage(request: request))
        tableView.setContentOffset(.zero, animated: true)
    }
    
    private func requestNextPageForMovies() {
        guard !titleForSearching.isEmpty else {
            return
        }
        
        let request = MoviesList.Movies.Request(title: titleForSearching)
        viewModel.fetchData(type: .nextPage(request: request))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: LoadingTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LoadingTableViewCell.self))
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholderText
        searchController.searchBar.tintColor = .black
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension MoviesListViewController {
    private func bind() {
        viewModel.isLoading.bind(self, performInitialUpdate: false, clearPreviousBinds: false) { [weak self] isLoaing in
            switch isLoaing {
            case true:
                guard let controller = self?.searchController else {
                    return
                }
                
                self?.showLoadingView(on: controller)
            case false:
                self?.hideLoadingView()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.error.bind(self) { [weak self] error in
            guard let error = error as? NetworkResponseError else {
                return
            }
            
            self?.show(error: error)
        }
        
        viewModel.message.bind(self) { [weak self] message in
            guard let message = message else {
                return
            }
            
            self?.show(message: message.description, title: message.title)
        }
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellConfigurations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.cellConfigurations.count else {
            return UITableViewCell()
        }
        
        var cell = UITableViewCell()
        
        let cellType = viewModel.cellConfigurations[indexPath.row].cellType
        
        switch cellType {
        case .movie:
            guard let movieCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self), for: indexPath) as? ConfigurableTableViewCell else {
                return cell
            }
            
            movieCell.congigureCell(with: viewModel.cellConfigurations[indexPath.row].configuration)
            
            cell = movieCell
        case .loading:
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingTableViewCell.self), for: indexPath) as? ConfigurableTableViewCell else {
                return cell
            }
            
            loadingCell.congigureCell(with: viewModel.cellConfigurations[indexPath.row].configuration)
            
            cell = loadingCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard cell is LoadingTableViewCell else {
            return
        }
        
        requestNextPageForMovies()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleMovieSelection(for: indexPath.row)
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let titleForSearching = searchBar.text else {
            return
        }
        
        requestFirstPageForMovies(with: titleForSearching)
    }
}
