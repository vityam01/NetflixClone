//
//  UpcomingViewModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 19.05.2022.
//

import Foundation
import UIKit




class UpcomingViewModel {
    
    let titleText = LocalizationKeys.Constollers.Name.upcoming.rawValue.localized
    let upcomingKey = "upcoming"
    var titles: [Title] = [Title]()
    
    func itemsCount(section: Int) -> Int {
        return titles.count
    }
    
    func cellForRow(indexPath: IndexPath) -> Title {
        return titles[indexPath.row]
    }

    func heightForRowAt() -> CGFloat {
        return 140
    }
    
    func heightForHeaderInSection() -> CGFloat {
       return 45
    }
    
    func getData(complerion: @escaping ()-> Void) {
        APICaller.shared.getMovies(keyValue: upcomingKey) { [ weak self ] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                complerion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func initializeCell(indexPath: IndexPath) -> TitleViewModel {
        let title = titles[indexPath.row]
        return TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown name", posterURL: title.poster_path ?? "")
    }
    
    func didSelectRow(indexPath: IndexPath, completion: @escaping (VideoElement, Title) -> Void) {
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        APICaller.shared.getMovie(with: titleName) { titles in
            switch titles {
            case .success(let videoElement):
                completion(videoElement, title)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
