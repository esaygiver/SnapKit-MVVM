//
//  String + Localizable.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 18.10.2021.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self,
                          tableName: "Localizable",
                          bundle: .main,
                          value: self,
                          comment: self)
    }
}
