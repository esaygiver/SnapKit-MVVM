//
//  MovieCollectionViewCell.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MovieCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var movieImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = Styling.font(fontName: .helvetica, weight: .semibold, size: 14)
        title.numberOfLines = 0
        title.textColor = .yellow
        title.textAlignment = .left
        title.backgroundColor = Styling.colorForCode(.black)
        return title
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setComponentConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setComponentConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMovieImage(on url: String?, contentMode: ContentMode = .scaleAspectFit, title: String? = "") {
        movieImageView.contentMode = contentMode
        url != "https://image.tmdb.org/t/p/w500" ?
            movieImageView.fetchImage(from: url ?? "") :
            movieImageView.fetchImage(from: getURL(on: .emptyImage))
        titleLabel.text = title
    }
}
//MARK: - Set Cell Components Outlets
extension MovieCollectionViewCell {
    private func setComponentConstraints() {
        addSubview(containerView)
        containerView.addSubviews(movieImageView, titleLabel)
        
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(contentView)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(containerView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(containerView.snp.left).offset(5)
            make.bottom.equalTo(containerView.snp.bottom).offset(-5)
            make.height.lessThanOrEqualTo(150)
        }
    }
}
