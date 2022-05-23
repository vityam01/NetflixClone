//
//  DownloadsViewModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 23.05.2022.
//

import Foundation
import UIKit

class DownloadsViewModel {
    
     var titles: [TitleItem] = [TitleItem]()

    
    let titleText = LocalizationKeys.Constollers.Name.downloaded.rawValue.localized

    
    func localStorage(completion: @escaping () -> Void) {
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [ weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func didSelecetRow(indexPath: IndexPath, competion: @escaping (TitleItem, VideoElement) -> Void) {
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        APICaller.shared.getMovie(with: titleName) { titles in
            switch titles {
            case .success(let videoElement):
                competion(title,videoElement)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteRow(indexPath: IndexPath, completion: @escaping ()-> Void) {
        DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
            switch result {
            case .success():
                print("Deleted from database")
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.titles.remove(at: indexPath.row)
            completion()
        }
    }
    
    func heightForRow() -> CGFloat {
        return 140
    }
    
    func addContent(indexPath: IndexPath) -> TitleViewModel {
        let title = titles[indexPath.row]
        return TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown name", posterURL: title.poster_path ?? "")
    }
    
    func numberOfRows(section: Int) -> Int {
       return titles.count
    }
    
}
