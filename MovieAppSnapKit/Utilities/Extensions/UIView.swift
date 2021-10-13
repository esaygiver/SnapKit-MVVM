//
//  UIView.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 7.10.2021.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({ addSubview($0) })
    }
}
