//
//  Cast.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import Foundation

struct Cast: Codable {
    let profilePath: String?
    let name: String?
    let id: Int?
    var profileStr: String? {
        return "\(getURL(on: .castProfileURL))\(profilePath ?? "")"
    }
    
    private enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path", name, id
    }
}

struct CastResponseModel: Codable {
    let cast: [Cast]
}
