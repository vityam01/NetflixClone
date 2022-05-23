//
//  ViewController.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 15.05.2022.
//

import UIKit

final class MainTabViewController: UITabBarController {

    //MARK: Constants
    let firstVC = UINavigationController(rootViewController: HomeViewController())
    let secondVC = UINavigationController(rootViewController: UpcomingViewController())
    let thirdVC = UINavigationController(rootViewController: SearchViewController())
    let fourthVC = UINavigationController(rootViewController: DownloadsViewController())
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    //MARK: Private Methods
    private func setupUI() {
        
        firstVC.title = LocalizationKeys.Bar.ItemsName.home.rawValue.localized
        secondVC.title = LocalizationKeys.Bar.ItemsName.comingSoon.rawValue.localized
        thirdVC.title = LocalizationKeys.Bar.ItemsName.topSearch.rawValue.localized
        fourthVC.title = LocalizationKeys.Bar.ItemsName.downloads.rawValue.localized
        
        view.backgroundColor = .systemBackground
        
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .label
        
        firstVC.tabBarItem.image = UIImage(systemName: "house")
        secondVC.tabBarItem.image = UIImage(systemName: "play.circle")
        thirdVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        fourthVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
       
        
        setViewControllers([firstVC,secondVC,thirdVC,fourthVC], animated: true)
    }
    
}


