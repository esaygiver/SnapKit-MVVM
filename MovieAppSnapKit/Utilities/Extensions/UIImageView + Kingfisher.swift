//
//  UIImageView + Kingfisher.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func fetchImage(from urlString: String) {
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url)
        }
    }
}
