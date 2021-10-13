//
//  Coordinate.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 3.10.2021.
//

import UIKit
import SafariServices

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
    
    class func goToURL(ID: Int?, and vc: UIViewController) {
        let selectedCastID = ID ?? 0
        if let url = URL(string: "\(getURL(on: .castTMDBPage))\(selectedCastID)") {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .popover
            safariVC.modalTransitionStyle = .crossDissolve
            vc.present(safariVC, animated: true)
        }
    }
    
    class func goToFavoriteVC(vc: UIViewController) {
        let favoriteVC = FavoriteViewController()
        vc.show(favoriteVC, sender: nil)
    }
}
