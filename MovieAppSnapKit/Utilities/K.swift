//
//  K.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 15.10.2021.
//

import UIKit

struct K {
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let emptyFirstBarImage: String = "firstImage"
    static let fillFirstBarImage: String = "firstImageFill"
    static let emptyFavoriteBarImage: String = "iconFavorilerim"
    static let fillFavoriteBarImage: String = "Favorilerim"

    //MARK: - CollectionView Ks
    static let cellMinimumLineSpacing: CGFloat = 10
    static let cellInsetForSectionAt: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    static let cellSizeForItemAt: CGSize = CGSize(width: screenWidth / 2 - 25, height: screenHeight * 0.3)
    static let castSizeForItemAt: CGSize = CGSize(width: screenWidth / 2 - 75, height: 180)
    
    //MARK: - TableView Ks
    static let tableViewHeightForRow: CGFloat = 200
    
    //MARK: - UI Ks
    static let favorited = "Favori"
    static let notFavorited = "Shape"
    static let play = "Play"
    static let pause = "pause-button"
    static let favoritedNotification = "isFavorited"
    static let favoritePageTitle = "Favorites"
    static let noMovieResults = "Sorry, There are no movies about your search"
    static let noCastResults = "Sorry, There is no cast about your search"
    static let noFavoritedMovie = "Sorry, There is no favorited movie"
    static let popularMovies = "Popular Movies"
    static let searchMovies = "Search Movies"
    static let movieResults = "Movie Results"
    static let castResults = "Cast Results"
    static let overview = "Overview"
    static let cast = "Cast"
}
