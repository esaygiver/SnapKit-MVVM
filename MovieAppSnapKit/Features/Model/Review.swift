//
//  Review.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import Foundation

struct Review: Codable {
    let content: String?
    let authorDetails: Author?
    
    private enum CodingKeys: String, CodingKey {
        case content, authorDetails = "author_details"
    }
}

struct Author: Codable {
    let userName: String?
    let rating: Double?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username", rating
    }
}

struct ReviewData: Codable {
    let review: [Review]
    
    private enum CodingKeys: String, CodingKey {
        case review = "results"
    }
}
