//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 15.05.2022.
//

import UIKit



final class SearchViewController: UIViewController {

    
    @IBOutlet weak private var searchTable: UITableView!
    
    private var viewModel: SearchViewControllerModel?
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for the movie of TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    //MARK: Private methods
    private func initUI() {
        self.viewModel = SearchViewControllerModel()
        configNavigation()
        view.backgroundColor = .systemBackground
        title = viewModel?.titleText ?? ""
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        searchTable.register(UINib(nibName: UpcomingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        searchTable.delegate = self
        searchTable.dataSource = self
        fetchMovies()
    }
    
    func configNavigation() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        searchController.searchResultsUpdater = self
    }
    
    private func fetchMovies() {
        guard let viewModel = viewModel else { return }
        viewModel.getMovies { [weak self] in
            DispatchQueue.main.async {
                self?.searchTable.reloadData()
            }
        }
    }

}

    //MARK: TableView Extension
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier,
                                                       for: indexPath) as? UpcomingTableViewCell, let viewModel = viewModel
                                                    else { return UITableViewCell() }
        cell.configure(with: viewModel.cellForRow(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRow() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        viewModel.didSelectRow(indexPath: indexPath) { [weak self] title, videoElement in
            DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                vc.configure(wirh: TitlePreviewViewModel(title: title.original_title ?? title.original_name ?? "",
                                                         youtubeView: videoElement,
                                                         titleOverview: title.overview ?? ""))
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

//MARK: SearchExtension
extension SearchViewController: UISearchResultsUpdating, SearchViewControllerDelegate {
    func searchViewControllerDidTappeditem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(wirh: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        guard let query = searchbar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= viewModel?.minimumChar() ?? 1,
              let resutlController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resutlController.delegate = self
        
        guard let viewModel = viewModel else { return }
        viewModel.updateSearch(query: query) { titles in
            resutlController.viewModel?.titles = titles
            resutlController.searchResultsCollectionView.reloadData()
        }
    }
}


