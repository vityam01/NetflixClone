//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 18.05.2022.
//

import Foundation
import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case PopularMovies = 2
    case UpcomingMovies = 3
    case TopMovies = 4
}

enum ParsingKeys: String, CaseIterable {
    case tvKey = "tv"
    case movieKey = "movie"
    case popularKey = "popular"
    case topKey = "top_rated"
    case upcomingKey = "upcoming"
}

final class HomeViewModel {
    
    let netflixImage = "netflixLogo"
    let personImage = "person"
    let playImage = "play.rectangle"
    
    let sectionTitles: [String] = [LocalizationKeys.List.KindOfList.trendingMovies.rawValue.localized, LocalizationKeys.List.KindOfList.trendingTv.rawValue.localized, LocalizationKeys.List.KindOfList.popular.rawValue.localized, LocalizationKeys.List.KindOfList.upcoming.rawValue.localized, LocalizationKeys.List.KindOfList.top.rawValue.localized]
    
    
    func heighForView() -> CGFloat {
        return 500
    }
    
    func cgRectForXandY() -> CGFloat {
        return 0
    }
    
    func numberOfSection() -> Int {
        sectionTitles.count
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        sectionTitles[section]
    }
    
    func heightForHeaderInSection() -> CGFloat {
       return 40
    }
    
    func heightForRowAt() -> CGFloat {
        return 200
    }
    
    func numberOfRowsInSection() -> Int {
        return 1
    }
    
    func contentForCell(indexPath: IndexPath, completion: @escaping ([Title]) -> Void) {
        let key = ParsingKeys.allCases[safe: indexPath.section]
        APICaller.shared.getMovies(keyValue: key?.rawValue ?? "") { result in
            switch result {
            case .success(let titles):
                completion(titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}
