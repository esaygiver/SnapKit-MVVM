//
//  UIButton + Favorite.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 19.10.2021.
//

import UIKit

struct FavoritedMovie {
    let id: Int
    let isFavorited: Bool
}

extension UIButton {
    
    func action(favStatus: inout Bool, movieObject: inout Movie?,
                vc: UIViewController,
                on view: UIView, likeView: UIView) {
        favStatus.toggle()
        view.addSubviews(likeView)
        if favStatus {
            movieObject?.isFavorited = true
            RealmManager().save(on: movieObject)
            Animate.addAnimation(on: likeView, and: vc)
        } else {
            movieObject?.isFavorited = false
            RealmManager().delete(movieObject: movieObject)
            likeView.removeFromSuperview()
        }
        let favoritedMovieObject = FavoritedMovie(id: movieObject?.id ?? 0, isFavorited: movieObject?.isFavorited ?? false)
        NotificationService.postNotification(name: K.favoritedNotification, object: favoritedMovieObject)
    }
}
