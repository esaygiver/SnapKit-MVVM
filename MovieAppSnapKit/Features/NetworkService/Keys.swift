//
//  Keys.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import Foundation

enum Keys: String, CaseIterable {
    case popularMoviesURL
    case imageURL
    case castProfileURL
    case APIKey
    case baseURL
    case youtubeURL
    case castTMDBPage
    case emptyImage
}

func getURL(on platform: Keys) -> String {
    let apiKey = "api_key=660a71826e07d00e08b7baa0a340d61b&language=en-US&"
    let baseURL = "https://api.themoviedb.org/3/"
    switch platform {
    case .baseURL:
        return "https://api.themoviedb.org/3/"
    case .APIKey:
        return "98c068aacfd03daaa1e7936e01146411"
    case .popularMoviesURL:
        return "\(baseURL)movie/popular?\(apiKey)"
    case .imageURL:
        return "https://image.tmdb.org/t/p/original"
    case .castProfileURL:
        return "https://image.tmdb.org/t/p/w500"
    case .youtubeURL:
        return "https://www.youtube.com/watch?v="
    case .castTMDBPage:
        return "https://www.themoviedb.org/person/"
    case .emptyImage:
        return "https://thesource.sa.ua.edu/wp-content/uploads/sites/57/2019/08/no-person-200x300.png"
    }
    
}
