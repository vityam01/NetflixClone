//
//  HomeScreenModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 23.05.2022.
//

import Foundation
import UIKit

class HomeScreenModel {
    
    let actionName = "Download"
    let downloaded = "downloaded"
    var titles: [Title] = [Title]()
    
    weak var delegate: CollectionTableViewCellDelegate?
    
    func modelIndex(indexPath: IndexPath) -> Title {
       return titles[indexPath.row]
    }
    
    func numberOfItemsInSection() -> Int {
        titles.count
    }
    
    func downloadTitle(indexPath: IndexPath) {
        DataPersistenceManager.shared.downloadTitleWith(model: modelIndex(indexPath: indexPath) ) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name(self.downloaded), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func viewBorderColour() -> CGColor {
        return UIColor.gray.cgColor
    }
    
    func cellBorder() -> CGFloat {
        return 1
    }
    
    func cellCornerRadius() -> CGFloat {
        return 8
    }
    
    func didSelectItem(indexPath: IndexPath, completion: @escaping (TitlePreviewViewModel)-> Void) {
        let title = modelIndex(indexPath: indexPath)
        guard let titleName = title.original_title ?? title.original_name else { return }

        APICaller.shared.getYouTubeMovie(with: titleName + "trailer") { result in
            switch result {
            case .success(let video):

                let title = title
                guard let titleOverview = title.overview else { return }
                let viewModel = TitlePreviewViewModel(title: titleName,
                                                      youtubeView: video,
                                                      titleOverview: titleOverview)
                completion(viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didSelectCell(indexPath: IndexPath, selfStrong: CollectionTableViewCell) {
        let title = modelIndex(indexPath: indexPath)
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APICaller.shared.getYouTubeMovie(with: titleName + "trailer") { [weak self] result in
            switch result {
            case .success(let video):
                
                let title = title
                guard let titleOverview = title.overview else { return }
                let viewModel = TitlePreviewViewModel(title: titleName,
                                                      youtubeView: video,
                                                      titleOverview: titleOverview)
                self?.delegate?.collectionTableViewCellDidTappedCell(selfStrong,
                                                               viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
       downloadTitle(indexPath: indexPath)
    }
    
    func actionForDownload(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: self?.actionName ?? "" ,
                                          subtitle: nil,
                                          image: nil,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
}
