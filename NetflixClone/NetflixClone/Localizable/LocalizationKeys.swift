//
//  LocalizationKeys.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 21.05.2022.
//

import Foundation


class LocalizationKeys {
    
    /// Service class containing the localization keys set
    ///
    /// The localization keys oredered by:
    ///
    ///  - LocalozationKeys.ModeuleName.ViewName.FieldName
    
    struct Constollers {
        enum Name: String, CaseIterable {
            case upcoming = "Constollers.Name.upcoming"
            case search = "Constollers.Name.search"
            case downloaded = "Constollers.Name.downloaded"
        }
    }
    
    struct Bar {
        enum ItemsName: String, CaseIterable {
            case home = "Bar.ItemsName.home"
            case comingSoon = "Bar.ItemsName.comingSoon"
            case topSearch = "Bar.ItemsName.topSearch"
            case downloads = "Bar.ItemsName.downloads"
        }
    }
    
    struct List {
        enum KindOfList: String, CaseIterable {
            case trendingMovies = "List.KindOfList.trendingMovies"
            case trendingTv = "List.KindOfList.trendingTv"
            case popular = "List.KindOfList.popular"
            case upcoming = "List.KindOfList.upcoming"
            case top = "List.KindOfList.top"
        }
    }
}
