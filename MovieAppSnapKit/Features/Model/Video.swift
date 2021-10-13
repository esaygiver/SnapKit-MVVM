//
//  Video.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import Foundation

struct Video: Codable {
    let key: String?
    
    private enum CodingKeys: String, CodingKey {
        case key
    }
}

struct VideoResults: Codable {
    let videos: [Video]
    
    private enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
}
