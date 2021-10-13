//
//  Coordinate.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 3.10.2021.
//

import UIKit

final class Coordinate {
    
    class func goToDetailViewController(on object: Movie?, and vc: UIViewController) {
        if let object = object {
            let detailVC = DetailViewController()
            detailVC.movieObject = object
            detailVC.delegate = vc as! DetailVCOutput
            detailVC.modalTransitionStyle = .flipHorizontal
            vc.present(detailVC, animated: true, completion: nil)
        }
    }
    
    class func goToFavoriteVC(vc: UIViewController) {
        let favoriteVC = FavoriteViewController()
        vc.show(favoriteVC, sender: nil)
    }
}
