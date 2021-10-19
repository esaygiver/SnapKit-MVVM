//
//  BaseView.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 15.10.2021.
//

import UIKit

class BaseView: UIView {
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI() { }
    
}
