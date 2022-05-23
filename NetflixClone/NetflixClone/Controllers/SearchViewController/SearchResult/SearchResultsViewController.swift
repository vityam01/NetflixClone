//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 20.05.2022.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewControllerDidTappeditem(_ viewModel: TitlePreviewViewModel)
}

final class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    
    var viewModel: SearchResultModel?
    weak var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
    }

    private func initUI() {
        self.viewModel = SearchResultModel()
        view.backgroundColor = .systemBackground
        searchResultsCollectionView.register(UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfSections(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCollectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        cell.configure(with: viewModel.cellForItem(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        viewModel.didSelectItem(indexPath: indexPath) { [weak self] title, videoElement in
            self?.delegate?.searchViewControllerDidTappeditem(TitlePreviewViewModel(title: title.original_name ?? title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))
        }
    } 
}
