//
//  SearchViewControllerModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 23.05.2022.
//

import Foundation
import UIKit

class SearchViewControllerModel {
    
    var titles: [Title] = [Title]()
    let titleText = LocalizationKeys.Constollers.Name.search.rawValue.localized
 
    
    func getMovies(completion: @escaping ()-> Void) {
        APICaller.shared.getDiscoverMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            
            }
        }

    }
    
    func minimumChar() -> Int {
        return 3
    }
    
    func updateSearch(query: String, compition: @escaping ([Title]) -> Void) {
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    compition(titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func didSelectRow(indexPath: IndexPath, completion: @escaping (Title, VideoElement)-> Void) {
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        APICaller.shared.getMovie(with: titleName) { titles in
            switch titles {
            case .success(let videoElement):
                completion(title, videoElement)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func heightForRow() -> CGFloat {
        return 140
    }
    
    func cellForRow(indexPath: IndexPath) -> TitleViewModel {
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "")
        return model
    }
    
    func numberOfRows(section: Int)-> Int {
        return titles.count
    }
}
