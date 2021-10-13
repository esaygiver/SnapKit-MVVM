//
//  MovieInteraptor.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 12.10.2021.
//

import Foundation

struct MovieInteraptor {
    
    func fetchFavoriteds(on model: MovieModel) -> MovieModel {
        let newModel = MovieModel(movie: model.movie,
                                  totalPage: model.totalPage,
                                  totalNumber: model.totalNumber)
        if let fetchedFavs = RealmManager().fetch() {
            newModel.movie?.forEach({ movieObject in
                fetchedFavs.forEach { favs in
                    movieObject.isFavorited = movieObject.id == favs.id ? true : false
                }
            })
            if fetchedFavs.isEmpty {
                newModel.movie?.forEach({ $0.isFavorited = false })
            }
        }
        return newModel
    }
}
