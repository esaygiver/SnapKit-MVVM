//
//  Person.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 5.10.2021.
//

import Foundation

struct PersonResults: Codable {
    let page, totalPages, totalResults: Int
    let person: [Person]?

    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case person = "results"
    }
}

// MARK: - Result
struct Person: Codable {
    let id: Int?
    let name, profilePath: String?
    var profileStr: String? {
        return "\(getURL(on: .castProfileURL))\(profilePath ?? "")"
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePath = "profile_path"
    }
}
