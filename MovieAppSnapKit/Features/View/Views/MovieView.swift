//
//  MovieView.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 15.10.2021.
//

import UIKit

public enum ScreenState  {
    case searching
    case loaded
    case loading
}

//class MovieView: BaseView {
//
//    private lazy var searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search Movies"
//        searchBar.configure()
//        return searchBar
//    }()
//
//    private let categoryTitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = Styling.font(fontName: .helvetica, weight: .bold, size: 18)
//        label.textColor = Styling.colorForCode(.black)
//        label.backgroundColor = .clear
//        return label
//    }()
//
//    private let castTitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = Styling.font(fontName: .helvetica, weight: .bold, size: 18)
//        label.textColor = Styling.colorForCode(.black)
//        label.backgroundColor = .clear
//        return label
//    }()
//
//    private lazy var popularMoviesCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
//        layout.scrollDirection = .vertical
//        collectionView.collectionViewLayout = layout
//        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
//        collectionView.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        collectionView.bounces = false
//        return collectionView
//    }()
//
//    private lazy var searchedMoviesCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
//        layout.scrollDirection = .horizontal
//        collectionView.collectionViewLayout = layout
//        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
//        collectionView.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        collectionView.bounces = false
//        return collectionView
//    }()
//
//    private lazy var searchedPersonsCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
//        layout.scrollDirection = .horizontal
//        collectionView.collectionViewLayout = layout
//        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
//        collectionView.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        collectionView.bounces = false
//        return collectionView
//    }()
//
//    private lazy var loadingView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        return view
//    }()
//
//    private let titleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        return view
//    }()
//
//    private let appTitle: UILabel = {
//        var label = UILabel()
//        label.text = "MovieDB"
//        label.textAlignment = .center
//        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 30)
//        label.textColor = .black
//        return label
//    }()
//
//    private let searchingView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        return view
//    }()
//
//    private let emptyMovieView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        view.isHidden = true
//        return view
//    }()
//
//    private let emptyMovieEmojiLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
//        label.text = "🎭"
//        label.textAlignment = .center
//        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 55)
//        return label
//    }()
//
//    private let emptyMovieTitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = Styling.font(fontName: .helvetica, weight: .regular, size: 20)
//        label.textColor = Styling.colorForCode(.black)
//        label.backgroundColor = .clear
//        label.textAlignment = .center
//        label.text = "Sorry, There is no movies about your search"
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private let emptyPersonView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
//        view.isHidden = true
//        return view
//    }()
//
//    private let emptyPersonEmojiLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .clear
//        label.text = "👥"
//        label.textAlignment = .center
//        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 55)
//        return label
//    }()
//
//    private let emptyPersonTitleLabel: UILabel = {
//        let label = UILabel()
//        label.font = Styling.font(fontName: .helvetica, weight: .regular, size: 20)
//        label.textColor = Styling.colorForCode(.black)
//        label.backgroundColor = .clear
//        label.textAlignment = .center
//        label.text = "Sorry, There is no casts about your search"
//        label.numberOfLines = 0
//        return label
//    }()
//
//
//    private let activityIndicator: UIActivityIndicatorView = {
//        let ind = UIActivityIndicatorView()
//        ind.color = .red
//        ind.style = .medium
//        return ind
//    }()
//
//    private var screenState: ScreenState? {
//        didSet {
//            switch screenState {
//            case .loaded:
//                loadingView.isHidden = true
//                categoryTitleLabel.text = "Popular Movies"
//                popularMoviesCollectionView.isHidden = false
//                searchingView.isHidden = true
//            case .searching:
//                popularMoviesCollectionView.isHidden = true
//                searchingView.isHidden = false
//                emptyMovieView.isHidden = true
//                emptyPersonView.isHidden = true
//            case .loading:
//                popularMoviesCollectionView.isHidden = true
//                loadingView.isHidden = false
//            default:
//                //no-op
//                break
//            }
//        }
//    }
//
//    override func configureUI() {
//        super.configureUI()
//        setComponentsConstraints()
//    }
//
//    private func setComponentsConstraints() {
//        titleView.addSubview(appTitle)
//        searchingView.addSubviews(searchedMoviesCollectionView, castTitleLabel, searchedPersonsCollectionView, emptyMovieView, emptyPersonView)
//        emptyMovieView.addSubviews(emptyMovieEmojiLabel, emptyMovieTitleLabel)
//        emptyPersonView.addSubviews(emptyPersonEmojiLabel, emptyPersonTitleLabel)
//
//        titleView.snp.makeConstraints { (make) in
//            make.top.equalTo(self).offset(30)
//            make.right.left.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        appTitle.alpha = 0
//        UIView.animate(withDuration: 2) {
//            self.appTitle.snp.makeConstraints { (make) in
//                self.appTitle.alpha = 1
//                make.height.equalTo(30)
//                make.left.right.equalTo(self.titleView)
//                make.top.equalTo(self.titleView.snp.top).offset(10)
//            }
//        }
//
//        searchBar.snp.makeConstraints { (make) in
//            make.top.equalTo(titleView.snp.bottom)
//            make.left.equalToSuperview().offset(-5)
//            make.right.equalToSuperview().offset(5)
//            make.height.equalTo(40)
//        }
//
//        categoryTitleLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(searchBar.snp.bottom).offset(20)
//            make.right.equalToSuperview()
//            make.left.equalToSuperview().offset(10)
//            make.height.equalTo(25)
//        }
//
//        emptyMovieView.snp.makeConstraints { make in
//            make.top.equalTo(categoryTitleLabel.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(castTitleLabel.snp.top)
//        }
//
//        emptyMovieEmojiLabel.snp.makeConstraints { make in
//            make.top.equalTo(emptyMovieView.snp.top).offset(35)
//            make.left.equalTo(emptyMovieView.snp.left).offset(15)
//            make.right.equalTo(emptyMovieView.snp.right).offset(-15)
//            make.height.equalTo(100)
//        }
//
//        emptyMovieTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(emptyMovieEmojiLabel.snp.bottom).offset(-80)
//            make.left.equalTo(emptyMovieView.snp.left).offset(20)
//            make.right.equalTo(emptyMovieView.snp.right).offset(-20)
//            make.height.equalTo(200)
//        }
//
//        emptyPersonView.snp.makeConstraints { make in
//            make.top.equalTo(castTitleLabel.snp.bottom).offset(10)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(self.snp.bottom).offset(-100)
//        }
//
//        emptyPersonEmojiLabel.snp.makeConstraints { make in
//            make.top.equalTo(emptyPersonView.snp.top).offset(35)
//            make.left.equalTo(emptyPersonView.snp.left).offset(15)
//            make.right.equalTo(emptyPersonView.snp.right).offset(-15)
//            make.height.equalTo(100)
//        }
//
//        emptyPersonTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(emptyPersonEmojiLabel.snp.bottom).offset(-80)
//            make.left.equalTo(emptyPersonView.snp.left).offset(20)
//            make.right.equalTo(emptyPersonView.snp.right).offset(-20)
//            make.height.equalTo(200)
//        }
//
//        popularMoviesCollectionView.snp.makeConstraints { (make) in
//            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(20)
//            make.left.equalTo(categoryTitleLabel)
//            make.right.equalToSuperview().offset(-10)
//            make.bottom.equalTo(self.snp.bottom).offset(-100)
//        }
//
//        loadingView.snp.makeConstraints { make in
//            make.left.right.top.bottom.equalTo(popularMoviesCollectionView)
//        }
//
//        activityIndicator.snp.makeConstraints { (make) in
//            make.top.equalTo(searchBar.snp.bottom)
//            make.right.equalToSuperview().offset(-10)
//            make.height.width.equalTo(50)
//        }
//
//        searchingView.snp.makeConstraints { (make) in
//            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(10)
//            make.right.equalTo(searchBar).offset(-20)
//            make.left.equalTo(searchBar).offset(20)
//            make.bottom.equalTo(self.snp.bottom).offset(-100)
//        }
//
//        searchedMoviesCollectionView.snp.makeConstraints { make in
//            make.top.left.right.equalTo(searchingView)
//            make.height.equalTo(300)
//        }
//
//        castTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(searchedMoviesCollectionView.snp.bottom).offset(10)
//            make.left.right.height.equalTo(categoryTitleLabel)
//        }
//
//        searchedPersonsCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(castTitleLabel.snp.bottom).offset(10)
//            make.left.right.height.equalTo(searchedMoviesCollectionView)
//        }
//    }
//
//    public func setDelegates(on vc: UIViewController) {
//        searchBar.delegate = vc as? UISearchBarDelegate
//        popularMoviesCollectionView.delegate = vc as? UICollectionViewDelegate
//        popularMoviesCollectionView.dataSource = vc as? UICollectionViewDataSource
//        searchedMoviesCollectionView.delegate = vc as? UICollectionViewDelegate
//        searchedMoviesCollectionView.dataSource = vc as? UICollectionViewDataSource
//        searchedPersonsCollectionView.delegate = vc as? UICollectionViewDelegate
//        searchedPersonsCollectionView.dataSource = vc as? UICollectionViewDataSource
//    }
//
//}
