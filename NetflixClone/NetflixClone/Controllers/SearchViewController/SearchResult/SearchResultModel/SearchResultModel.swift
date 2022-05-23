//
//  SearchResultModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 23.05.2022.
//

import Foundation


class SearchResultModel {
    
    public var titles: [Title] = [Title]()

    
    func numberOfSections(section: Int) -> Int {
        return titles.count
        
    }
    
    func cellForItem(indexPath: IndexPath) -> String {
    guard let title = titles[indexPath.row].poster_path else { return "" }
       return title
    }
    
    func didSelectItem(indexPath: IndexPath, completion: @escaping (Title,VideoElement)-> Void) {
        let title = titles[indexPath.row]
        let titleName = title.original_name ?? ""
        APICaller.shared.getMovie(with: titleName) { titles in
            switch titles {
            case .success(let videoElement):
                completion(title, videoElement)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
