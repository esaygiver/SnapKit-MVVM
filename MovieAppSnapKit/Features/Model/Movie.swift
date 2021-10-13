//
//  Movie.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import Foundation

class Movie: Codable {
    
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    let overview: String?
    let id: Int?
    let backDrop: String?
    let rate: Double?
    var isFavorited: Bool = false
    
    var posterStr: String? {
        return "\(getURL(on: .imageURL))\(posterPath ?? "")"
    }
    var backdropStr: String? {
        return "\(getURL(on: .imageURL))\(backDrop ?? "")"
    }
    
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path", backDrop = "backdrop_path", rate = "vote_average", releaseDate = "release_date", title, overview, id
    }
    
    init(title: String?, posterPath: String?, releaseDate: String?, overview: String?, id: Int?, backDrop: String?, rate: Double?, isFavorited: Bool = false) {
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.overview = overview
        self.id = id
        self.backDrop = backDrop
        self.rate = rate
        self.isFavorited = isFavorited
    }
}

struct DataResults: Codable {
    let page: Int
    let movies: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results", page, totalPages = "total_pages", totalResults = "total_results"
    }
}
