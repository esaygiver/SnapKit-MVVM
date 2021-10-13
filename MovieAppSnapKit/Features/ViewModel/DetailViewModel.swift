//
//  DetailViewModel.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 6.10.2021.
//

import Foundation

protocol DetailViewModelOutput {
    func fetchCast(movieID: Int)
    func setDelegates(output: DetailViewControllerOutput)
    func fetchTrailers(movieID: Int)
    var detailPageService: Networkable { get }
    var detailOutput: DetailViewControllerOutput? { get }
}

class DetailViewModel: DetailViewModelOutput {
  
    var detailOutput: DetailViewControllerOutput?
    var detailPageService: Networkable
    init() {
        detailPageService = NetworkManager()
    }
    
    func setDelegates(output: DetailViewControllerOutput) {
        detailOutput = output
    }
    
    func fetchCast(movieID: Int) {
        detailPageService.fetchCast(movieID: movieID) { [weak self] castResponse in
            if let castResponse = castResponse {
                self?.detailOutput?.fetchCast(results: castResponse)
            }
        }
    }
    
    func fetchTrailers(movieID: Int) {
        detailPageService.fetchTrailers(movieID: movieID) { [weak self] videoResponse in
            if let videoResponse = videoResponse {
                self?.detailOutput?.fetchTrailers(results: videoResponse)
            }
        }
    }
}
