//
//  RealmManager.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 3.10.2021.
//

import UIKit
import RealmSwift

class RealmManager {
    
    let realm = try! Realm()
    
    public func save(on movieObject: Movie?) {
        if let movieObject = movieObject {
            let favoritedMovieRealmObject = MovieObject()
            favoritedMovieRealmObject.movieTitle = movieObject.title ?? ""
            favoritedMovieRealmObject.moviePoster = movieObject.backdropStr ?? ""
            favoritedMovieRealmObject.movieID = movieObject.id ?? 0
            favoritedMovieRealmObject.movieOverview = movieObject.overview ?? ""
            favoritedMovieRealmObject.movieRate = movieObject.rate ?? 0.0
            favoritedMovieRealmObject.movieReleaseDate = movieObject.releaseDate ?? ""
            favoritedMovieRealmObject.isFavorited = true
            realm.beginWrite()
            realm.add(favoritedMovieRealmObject)
            try! realm.commitWrite()
        }
    }
    
    public func fetch() -> [Movie]? {
        var favoritedMovies = [Movie]()
        let favoritedMoviesInRealm = realm.objects(MovieObject.self)
        favoritedMoviesInRealm.forEach { realmMovieObject in
            let realMovieObject = Movie(title: realmMovieObject.movieTitle,
                                        posterPath: nil,
                                        releaseDate: realmMovieObject.movieReleaseDate,
                                        overview: realmMovieObject.movieOverview,
                                        id: realmMovieObject.movieID,
                                        backDrop: realmMovieObject.moviePoster,
                                        rate: realmMovieObject.movieRate,
                                        isFavorited: realmMovieObject.isFavorited)
            favoritedMovies.append(realMovieObject)
        }
        return favoritedMovies
    }
    
    public func delete(movieObject: Movie?) {
        if let movieObject = movieObject {
            let favoritedMoviesInRealm = realm.objects(MovieObject.self)
            favoritedMoviesInRealm.forEach { realmMovieObject in
                if realmMovieObject.movieID == movieObject.id {
                    realm.beginWrite()
                    realm.delete(realmMovieObject)
                    try! realm.commitWrite()
                }
            }
        }
    }
}


