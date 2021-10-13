//
//  MovieViewController.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 30.09.2021.
//

import UIKit
import SnapKit
import SwiftUI


protocol MovieViewControllerOutput {
    func getSearchedMovies(results: MovieModel)
    func getPopularMovies(results: MovieModel)
    func getSearchedPersons(results: PersonModel)
    func changeLoading(isLoad: Bool)
}

fileprivate enum ScreenState  {
    case searching
    case loaded
    case loading
}

final class MovieViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search Movies"
        searchBar.configure()
        return searchBar
    }()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Styling.font(fontName: .helvetica, weight: .bold, size: 18)
        label.textColor = Styling.colorForCode(.black)
        label.backgroundColor = .clear
        return label
    }()
    
    private let castTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Styling.font(fontName: .helvetica, weight: .bold, size: 18)
        label.textColor = Styling.colorForCode(.black)
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var popularMoviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Styling.colorForCode(.moreLighterGray)
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var searchedMoviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Styling.colorForCode(.moreLighterGray)
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var searchedPersonsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Styling.colorForCode(.moreLighterGray)
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        return view
    }()
    
    private let appTitle: UILabel = {
        var label = UILabel()
        label.text = "MovieDB"
        label.textAlignment = .center
        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 30)
        label.textColor = .black
        return label
    }()
    
    private let searchingView: UIView = {
        let view = UIView()
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        return view
    }()
    
    private let emptyMovieView: UIView = {
        let view = UIView()
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        view.isHidden = true
        return view
    }()
    
    private let emptyMovieEmojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "🎭"
        label.textAlignment = .center
        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 55)
        return label
    }()
    
    private let emptyMovieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Styling.font(fontName: .helvetica, weight: .regular, size: 20)
        label.textColor = Styling.colorForCode(.black)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = "Sorry, There is no movies about your search"
        label.numberOfLines = 0
        return label
    }()
    
    private let emptyPersonView: UIView = {
        let view = UIView()
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        view.isHidden = true
        return view
    }()
    
    private let emptyPersonEmojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "👥"
        label.textAlignment = .center
        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 55)
        return label
    }()
    
    private let emptyPersonTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Styling.font(fontName: .helvetica, weight: .regular, size: 20)
        label.textColor = Styling.colorForCode(.black)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = "Sorry, There is no casts about your search"
        label.numberOfLines = 0
        return label
    }()
   
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.color = .red
        ind.style = .medium
        return ind
    }()
    
    private var screenState: ScreenState? {
        didSet {
            switch screenState {
            case .loaded:
                loadingView.isHidden = true
                categoryTitleLabel.text = "Popular Movies"
                popularMoviesCollectionView.isHidden = false
                searchingView.isHidden = true
            case .searching:
                popularMoviesCollectionView.isHidden = true
                searchingView.isHidden = false
                emptyMovieView.isHidden = true
                emptyPersonView.isHidden = true
            case .loading:
                popularMoviesCollectionView.isHidden = true
                loadingView.isHidden = false
            default:
                //no-op
                break
            }
        }
    }
    
    private var popularMovies = MovieModel()
    private var searchedMovies = MovieModel()
    private var searchedPersons = PersonModel()
    private lazy var viewModel = MovieViewModel()
    private lazy var currentPage: Int = 1
    private lazy var searchedTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        NotificationService.setBadgeValue(on: self)
        viewModel.setDelegates(output: self)
        fetchPopularMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMovieDataChanged()
    }
    
    private func checkMovieDataChanged() {
        NotificationCenter.default.addObserver(forName: Notification.Name("isFavorited"), object: nil, queue: .main) { [weak self] notification in
            self?.isFetchingNecessary(notification)
        }
    }
    
    @objc func isFetchingNecessary(_ newObject: Notification) {
        if let isFavorited = newObject.object as? Bool, !isFavorited {
            popularMovies.movie = []
            fetchPopularMovies()
        }
    }
    
    private func fetchPopularMovies() {
        changeLoading(isLoad: true)
        DispatchQueue.main.async { [weak self] in
            self?.screenState = .loading
            self?.viewModel.fetchPopularMovies(page: self?.currentPage ?? 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            self?.screenState = .loaded
        })
    }
    
    private func configureUI() {
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        self.navigationController?.navigationBar.isHidden = true
        view.addSubviews(titleView, searchBar, categoryTitleLabel, loadingView, popularMoviesCollectionView, searchingView, activityIndicator)
        titleView.addSubview(appTitle)
        searchingView.addSubviews(searchedMoviesCollectionView, castTitleLabel, searchedPersonsCollectionView, emptyMovieView, emptyPersonView)
        emptyMovieView.addSubviews(emptyMovieEmojiLabel, emptyMovieTitleLabel)
        emptyPersonView.addSubviews(emptyPersonEmojiLabel, emptyPersonTitleLabel)
        //set components constraints
        setComponentsConstraints()
        //states
        screenState = .loaded
    }
}
//MARK: - UIComponents Constraints
extension MovieViewController {
    
    private func setComponentsConstraints() {
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(30)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        appTitle.alpha = 0
        UIView.animate(withDuration: 2) {
            self.appTitle.snp.makeConstraints { (make) in
                self.appTitle.alpha = 1
                make.height.equalTo(30)
                make.left.right.equalTo(self.titleView)
                make.top.equalTo(self.titleView.snp.top).offset(10)
            }
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(5)
            make.height.equalTo(40)
        }
        
        categoryTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        
        emptyMovieView.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(castTitleLabel.snp.top)
        }
        
        emptyMovieEmojiLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyMovieView.snp.top).offset(35)
            make.left.equalTo(emptyMovieView.snp.left).offset(15)
            make.right.equalTo(emptyMovieView.snp.right).offset(-15)
            make.height.equalTo(100)
        }
        
        emptyMovieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyMovieEmojiLabel.snp.bottom).offset(-80)
            make.left.equalTo(emptyMovieView.snp.left).offset(20)
            make.right.equalTo(emptyMovieView.snp.right).offset(-20)
            make.height.equalTo(200)
        }
        
        emptyPersonView.snp.makeConstraints { make in
            make.top.equalTo(castTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }
        
        emptyPersonEmojiLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyPersonView.snp.top).offset(35)
            make.left.equalTo(emptyPersonView.snp.left).offset(15)
            make.right.equalTo(emptyPersonView.snp.right).offset(-15)
            make.height.equalTo(100)
        }

        emptyPersonTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyPersonEmojiLabel.snp.bottom).offset(-80)
            make.left.equalTo(emptyPersonView.snp.left).offset(20)
            make.right.equalTo(emptyPersonView.snp.right).offset(-20)
            make.height.equalTo(200)
        }
        
        popularMoviesCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(categoryTitleLabel)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }
        
        loadingView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(popularMoviesCollectionView)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.right.equalToSuperview().offset(-10)
            make.height.width.equalTo(50)
        }
        
        searchingView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(10)
            make.right.equalTo(searchBar).offset(-20)
            make.left.equalTo(searchBar).offset(20)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }
        
        searchedMoviesCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(searchingView)
            make.height.equalTo(300)
        }
        
        castTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchedMoviesCollectionView.snp.bottom).offset(10)
            make.left.right.height.equalTo(categoryTitleLabel)
        }
        
        searchedPersonsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castTitleLabel.snp.bottom).offset(10)
            make.left.right.height.equalTo(searchedMoviesCollectionView)
        }
    }
}
//MARK: - UISearchBar Delegate
extension MovieViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchedText = searchBar.text, !searchedText.isEmpty else { return }
        screenState = .searching
        searchedTitle = searchedText
        searchedMovies.movie = []
        searchedPersons.person = []
        currentPage = 1
        viewModel.fetchSearchedItems(query: searchedText, page: currentPage)
        viewModel.fetchSearchedPersons(query: searchedText, page: currentPage)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        screenState = .loaded
        searchBar.resignFirstResponder()
    }
}
//MARK: - UICollectionView Delegate
extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularMoviesCollectionView:
            return popularMovies.movie?.count ?? 0
        case searchedMoviesCollectionView:
            return searchedMovies.movie?.count ?? 0
        case searchedPersonsCollectionView:
            return searchedPersons.person?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        switch collectionView {
        case popularMoviesCollectionView:
            if let popularMovieObject = popularMovies.movie {
                movieCell.setMovieImage(on: popularMovieObject[indexPath.row].posterStr)
            }
        case searchedMoviesCollectionView:
            if let searchedMovieObject = searchedMovies.movie {
                movieCell.setMovieImage(on: searchedMovieObject[indexPath.row].posterStr)
            }
        case searchedPersonsCollectionView:
            if let searchedPersonObject = searchedPersons.person {
                let searchedPerson = searchedPersonObject[indexPath.row]
                movieCell.setMovieImage(on: searchedPerson.profileStr,
                                        title: searchedPerson.name)
            }
        default:
            break
        }
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case popularMoviesCollectionView:
            Coordinate.goToDetailViewController(on: popularMovies.movie?[indexPath.row], and: self)
        case searchedMoviesCollectionView:
            Coordinate.goToDetailViewController(on: searchedMovies.movie?[indexPath.row], and: self)
        case searchedPersonsCollectionView:
            Coordinate.goToURL(ID: searchedPersons.person?[indexPath.row].id, and: self)
        default:
            break
        }
    }
}
//MARK: - UICollectionView FlowLayoutDelegate
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 25, height: view.frame.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case popularMoviesCollectionView:
            if indexPath.row == (popularMovies.movie?.count ?? 0) - 1 && currentPage <= popularMovies.totalPage ?? 0 {
                currentPage += 1
                changeLoading(isLoad: true)
                viewModel.fetchPopularMovies(page: currentPage)
            }
        case searchedMoviesCollectionView:
            if indexPath.row == (searchedMovies.movie?.count ?? 0) - 1 && currentPage <= searchedMovies.totalPage ?? 0 {
                currentPage += 1
                changeLoading(isLoad: true)
                viewModel.fetchSearchedItems(query: searchedTitle, page: currentPage)
            }
        case searchedPersonsCollectionView:
            if indexPath.row == (searchedPersons.person?.count ?? 0) - 1 && currentPage <= searchedPersons.totalPage ?? 0 {
                currentPage += 1
                changeLoading(isLoad: true)
                viewModel.fetchSearchedPersons(query: searchedTitle, page: currentPage)
            }
        default:
            break
        }
    }
}
//MARK: - Connection With Outputs
extension MovieViewController: MovieViewControllerOutput {
    
    func getSearchedMovies(results: MovieModel) {
        searchedMovies.movie?.append(contentsOf: results.movie ?? [])
        searchedMovies.totalPage = results.totalPage
        searchedMovies.totalNumber = results.totalNumber
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.emptyMovieView.isHidden = self.searchedMovies.totalNumber == 0 ? false : true
            self.searchedMoviesCollectionView.reloadData()
            self.categoryTitleLabel.text = "'\(self.searchedTitle)' Movie Results -> \(results.totalNumber ?? 0)"
        }
    }
    
    func getSearchedPersons(results: PersonModel) {
        searchedPersons.person?.append(contentsOf: results.person ?? [])
        searchedPersons.totalPage = results.totalPage
        searchedPersons.totalNumber = results.totalNumber
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.emptyPersonView.isHidden = self.searchedPersons.totalNumber == 0 ? false : true
            self.searchedPersonsCollectionView.reloadData()
            self.castTitleLabel.text = "'\(self.searchedTitle)' Cast Results -> \(results.totalNumber ?? 0)"
        }
    }
    
    func getPopularMovies(results: MovieModel) {
        popularMovies.movie?.append(contentsOf: results.movie ?? [])
        popularMovies.totalNumber = results.totalNumber
        popularMovies.totalPage = results.totalPage
        DispatchQueue.main.async { [weak self] in
            self?.popularMoviesCollectionView.reloadData()
        }
    }
 
    
    func changeLoading(isLoad: Bool) {
        if isLoad {
            UIView.animate(withDuration: 1) {
                self.activityIndicator.isHidden = false
                self.activityIndicator.transform = CGAffineTransform(scaleX: 2.1, y: 2.1)
            }
            activityIndicator.startAnimating()
        } else {
            UIView.animate(withDuration: 1) {
                self.activityIndicator.isHidden = true
                self.activityIndicator.transform = .identity
            }
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }
}
extension MovieViewController: DetailVCOutput {
    func detailVCDismissStatus(state: Bool) {
        state == true ? NotificationService.setBadgeValue(on: self) : print("Nothing changed")
    }
}

