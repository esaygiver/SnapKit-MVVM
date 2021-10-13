//
//  NetworkManager.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import Foundation
import Moya

typealias movieCompletion = (MovieModel?) -> ()
typealias personCompletion = (PersonModel?) -> ()
typealias castCompletion = ([Cast]?) -> ()
typealias videoCompletion = ([Video]?) -> ()

protocol Networkable {
    func fetchSearchingMovies(query: String, page: Int, completion: @escaping movieCompletion)
    func fetchPopularMovies(page: Int, completion: @escaping movieCompletion)
    func fetchSearchedPersons(query: String, page: Int, completion: @escaping personCompletion)
    func fetchCast(movieID: Int, completion: @escaping castCompletion)
    func fetchTrailers(movieID: Int, completion: @escaping videoCompletion)
}

class NetworkManager: Networkable {
    
    var provider = MoyaProvider<MovieAPI>(plugins: [NetworkLoggerPlugin()])

    func fetchSearchingMovies(query: String, page: Int, completion: @escaping movieCompletion) {
        provider.request(.search(query: query, page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    let movieObject = MovieModel(movie: results.movies,
                                                 totalPage: results.totalPages,
                                                 totalNumber: results.totalResults)
                    completion(movieObject)
                } catch let error {
                    print("Fetching error at searching movies: \(error)")
                    completion(nil)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchSearchedPersons(query: String, page: Int, completion: @escaping personCompletion) {
        provider.request(.searchPerson(query: query, page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(PersonResults.self, from: response.data)
                    let personObject = PersonModel(person: results.person,
                                                   totalPage: results.totalPages,
                                                   totalNumber: results.totalResults)
                    completion(personObject)
                } catch let error {
                    print("Fetching error at searching persons: \(error)")
                    completion(nil)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchPopularMovies(page: Int, completion: @escaping movieCompletion) {
        provider.request(.popular(page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                    let movieObject = MovieModel(movie: results.movies,
                                                 totalPage: results.totalPages,
                                                 totalNumber: results.totalResults)
                    completion(movieObject)
                } catch let error {
                    print("Fetching error at popular movies: \(error)")
                    completion(nil)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchCast(movieID: Int, completion: @escaping castCompletion) {
        provider.request(.cast(movieID: movieID)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(CastResponseModel.self, from: response.data)
                    completion(results.cast)
                } catch let error {
                    print("Fetching error at casts: \(error)")
                    completion(nil)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    public func fetchTrailers(movieID: Int, completion: @escaping videoCompletion) {
        provider.request(.video(movieID: movieID)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(VideoResults.self, from: response.data)
                    completion(results.videos)
                } catch let error {
                    print("Fetching error at trailers: \(error)")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    public func fetchReviews(movieID: Int, completion: @escaping ([Review]) -> ()) {
        provider.request(.review(movieID: movieID)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(ReviewData.self, from: response.data)
                    completion(results.review)
                } catch let error {
                    dump(error)
                }
            case let .failure(error):
                dump(error)
            }
        }
    }
}
