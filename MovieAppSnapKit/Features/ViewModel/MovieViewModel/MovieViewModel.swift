//
//  MovieViewModel.swift
//  MovieAppSnapKit
//
//  Created by Erol on 30.09.2021.
//

import Foundation

protocol MoviesViewModelOutput {
    func fetchSearchedItems(query: String, page: Int)
    func fetchSearchedPersons(query: String, page: Int)
    func fetchPopularMovies(page: Int)
    func changeLoading()
    func setDelegates(output: MovieViewControllerOutput)
    
    var moviesService: Networkable { get }
    var moviesOutput: MovieViewControllerOutput? { get }
}

class MovieViewModel: MoviesViewModelOutput {
    
    let moviesService: Networkable
    var moviesOutput: MovieViewControllerOutput?
    private var isLoading = false
    
    init() {
        moviesService = NetworkManager()
    }
    
    func setDelegates(output: MovieViewControllerOutput) {
        moviesOutput = output
    }
    
    func fetchSearchedPersons(query: String, page: Int) {
        changeLoading()
        moviesService.fetchSearchedPersons(query: query, page: page) { [weak self] (personResponse) in
            guard let self = self else { return }
            if let personResponse = personResponse {
                self.changeLoading()
                self.moviesOutput?.getSearchedPersons(results: personResponse)
            }
        }
    }
    
    func fetchSearchedItems(query: String, page: Int) {
        changeLoading()
        moviesService.fetchSearchingMovies(query: query, page: page) { [weak self] (movieResponse) in
            guard let self = self else { return }
            if let movieResponse = movieResponse {
                self.moviesOutput?.getSearchedMovies(results: movieResponse)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.changeLoading()
                }
            }
        }
    }
    
    func fetchPopularMovies(page: Int) {
        changeLoading()
        moviesService.fetchPopularMovies(page: page) { [weak self] (popularMovieResponse) in
            guard let self = self else { return }
            if let popularMovies = popularMovieResponse, !(popularMovies.movie?.isEmpty ?? true) {
                self.moviesOutput?.getPopularMovies(results: MovieInteraptor().fetchFavoriteds(on: popularMovies))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.changeLoading()
                }
            }
        }
    }
    
    func changeLoading() {
        isLoading.toggle()
        moviesOutput?.changeLoading(isLoad: isLoading)
    }
}
