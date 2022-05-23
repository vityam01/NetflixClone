//
//  CollectionTableViewCell.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 15.05.2022.
//

import UIKit

protocol CollectionTableViewCellDelegate: AnyObject {
    func collectionTableViewCellDidTappedCell(_ cell: CollectionTableViewCell, viewModel: TitlePreviewViewModel)
}


final class CollectionTableViewCell: UITableViewCell {
    
    
    weak var delegate: CollectionTableViewCellDelegate?
    private var viewModel: HomeScreenModel?
    
    
    
    @IBOutlet weak var scrollItemsView: UICollectionView!
    
    //MARK: Override
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func configure(with titles: [Title] ) {
        viewModel?.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.scrollItemsView.reloadData()
        }
    }
    
    //MARK: Private methods
    private func initUI() {
        scrollItemsView.register(UINib(nibName: HomeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        self.viewModel = HomeScreenModel()
        scrollItemsView.delegate = self
        scrollItemsView.dataSource = self
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.downloadTitle(indexPath: indexPath)
    }
}

    //MARK: Extension CollectionView
extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier,
                                                            for: indexPath) as? HomeCollectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        guard let poster = viewModel.modelIndex(indexPath: indexPath).poster_path else { return UICollectionViewCell() }
        cell.configure(with: poster )
        cell.layer.borderColor = viewModel.viewBorderColour()
        cell.layer.borderWidth = viewModel.cellBorder()
        cell.layer.cornerRadius = viewModel.cellCornerRadius() 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel?.didSelectItem(indexPath: indexPath, completion: { [weak self] data in
            guard let self = self else { return }
            self.delegate?.collectionTableViewCellDidTappedCell(self,
                                                           viewModel: data)
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let viewModel = viewModel else { return UIContextMenuConfiguration() }
        return viewModel.actionForDownload(indexPath: indexPath)
    }
}
