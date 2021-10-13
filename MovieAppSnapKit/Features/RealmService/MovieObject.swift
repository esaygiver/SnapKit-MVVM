//
//  MovieObject.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 3.10.2021.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @objc dynamic var movieTitle: String = ""
    @objc dynamic var moviePoster: String = ""
    @objc dynamic var movieID: Int = 0
    @objc dynamic var movieReleaseDate: String = ""
    @objc dynamic var movieOverview: String = ""
    @objc dynamic var movieRate: Double = 0.0
    @objc dynamic var isFavorited: Bool = false
}
