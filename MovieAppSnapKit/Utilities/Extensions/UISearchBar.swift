//
//  UISearchBar.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import UIKit

extension UISearchBar {
    
    func configure() {
        
        if #available(iOS 13.0, *) {
            self.searchTextField.font = Styling.font(fontName: .helvetica, weight: .bold, size: 15)
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            self.searchTextField.layer.cornerRadius = 6
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            self.searchTextField.layer.backgroundColor = Styling.colorForCode(.white).cgColor
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            self.searchTextField.textColor = Styling.colorForCode(.moreLighterGray)
        } else {
            // Fallback on earlier versions
        }
    }
}
