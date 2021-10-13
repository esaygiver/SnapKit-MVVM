//
//  API.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import Foundation

import Moya

enum MovieAPI {
    case search(query: String, page: Int)
    case searchPerson(query: String, page: Int)
    case popular(page: Int)
    case cast(movieID: Int)
    case video(movieID: Int)
    case review(movieID: Int)
}

fileprivate let APIKey = getURL(on: .APIKey)

extension MovieAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: getURL(on: .baseURL)) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .popular(_):
            return "movie/popular"
        case .cast(movieID: let movieID):
            return "movie/\(movieID)/credits"
        case .video(movieID: let movieID):
            return "movie/\(movieID)/videos"
        case .review(movieID: let movieID):
            return "movie/\(movieID)/reviews"
        case .search(_,_):
            return "search/movie"
        case .searchPerson(_,_):
            return "search/person"
        }
    }
    var method: Moya.Method {
        switch self {
        case  .search(_,_), .searchPerson(_,_), .popular(_), .cast(_), .video(_), .review(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(query: let query, page: let page), .searchPerson(query: let query, page: let page):
            return .requestParameters(parameters: ["api_key" : APIKey, "query": query, "page": page], encoding: URLEncoding.queryString)
        case .popular(page: let page):
            return .requestParameters(parameters: ["api_key" : APIKey, "page": page], encoding: URLEncoding.queryString)
        case .cast, .video(_), .review(_):
            return .requestParameters(parameters: ["api_key" : APIKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
