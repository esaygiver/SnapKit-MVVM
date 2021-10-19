//
//  MainTabBarController.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 2.10.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
    }
    
    private func setViewControllers() {
        let movieVC = MovieViewController()
        let favoriteVC = FavoriteViewController()
        let viewControllers: [UIViewController] = [movieVC, favoriteVC]
        var viewControllersWithNavigation: [UINavigationController] = []
        viewControllers.forEach { viewController in
            viewControllersWithNavigation.append(UINavigationController(rootViewController: viewController))
        }
        self.viewControllers = viewControllersWithNavigation
        self.tabBar.items?[0].image = UIImage(named: K.emptyFirstBarImage)
        self.tabBar.items?[0].selectedImage = UIImage(named: K.fillFirstBarImage)
        self.tabBar.items?[1].image = UIImage(named: K.emptyFavoriteBarImage)
        self.tabBar.items?[1].selectedImage = UIImage(named: K.fillFavoriteBarImage)
    }
}
