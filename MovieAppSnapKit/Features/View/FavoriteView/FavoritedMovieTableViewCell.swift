//
//  FavoritedMovieTableViewCell.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 3.10.2021.
//

import UIKit

class FavoritedMovieTableViewCell: UITableViewCell {

    static let identifier = "FavoritedMovieCell"
    
    private let containerView = UIView()
    private lazy var movieImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.alpha = 0.8
        return view
    }()
    
    private let movieTitle: UILabel = {
        let title = UILabel()
        title.font = Styling.font(fontName: .helvetica, weight: .bold, size: 18)
        title.numberOfLines = 0
        title.textColor = .yellow
        title.textAlignment = .center
        title.backgroundColor = .clear
        return title
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setComponentConstraints()
    }

    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setComponentConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFavoritedCell(on model: Movie) {
        movieTitle.text = model.title ?? ""
        movieImageView.fetchImage(from: model.backDrop ?? "")
    }
}
//MARK: - Set Cell Components Outlets
extension FavoritedMovieTableViewCell {
    private func setComponentConstraints() {
        contentView.addSubview(containerView)
        containerView.addSubview(movieImageView)
        containerView.addSubview(movieTitle)
        addingShadowAndCornerRadius()
        
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        movieImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(containerView)
        }
        movieTitle.snp.makeConstraints { make in
            make.left.right.equalTo(containerView)
            make.bottom.equalTo(containerView.snp.bottom).offset(-5)
            make.height.lessThanOrEqualTo(150)
        }
    }
}
extension FavoritedMovieTableViewCell {
    func addingShadowAndCornerRadius() {
        containerView.layer.borderWidth = 1.3
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 7.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.75
    }
}
