//
//  FavoriteViewController.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 2.10.2021.
//

import UIKit

final class FavoriteViewController: UIViewController {

    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        self.view.addSubview(view)
        return view
    }()
    
    private let favoriteTitleLabel: UILabel = {
        var label = UILabel()
        label.text = K.favoritePageTitle
        label.textAlignment = .center
        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 30)
        label.textColor = .black
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var favoritedMoviesTableView: UITableView = {
        let tv = UITableView()
        tv.register(FavoritedMovieTableViewCell.self, forCellReuseIdentifier: FavoritedMovieTableViewCell.identifier)
        tv.backgroundColor = Styling.colorForCode(.moreLighterGray)
        tv.bounces = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    //MARK: - Empty Situation
    private let emptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let emptyEmojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "😢"
        label.textAlignment = .center
        label.font = Styling.font(fontName: .thonburi, weight: .bold, size: 55)
        return label
    }()
    
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Styling.font(fontName: .helvetica, weight: .bold, size: 20)
        label.textColor = Styling.colorForCode(.black)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = K.noFavoritedMovie
        label.numberOfLines = 0
        return label
    }()
    
    private var favoritedMovies: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoritedMovies()
    }
    
    // Asks to RealmManager is there any favorited movies
    private func fetchFavoritedMovies() {
        favoritedMovies = RealmManager().fetch()
        DispatchQueue.main.async { [weak self] in
            self?.favoritedMoviesTableView.reloadData()
            self?.setScreenState()
        }
    }
    
    private func setScreenState() {
        emptyView.isHidden = (favoritedMovies?.isEmpty ?? true) ? false : true
        favoritedMoviesTableView.isHidden = (favoritedMovies?.isEmpty ?? true) ? true : false
    }
    
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        titleView.addSubview(favoriteTitleLabel)
        containerView.addSubviews(favoritedMoviesTableView, emptyView)
        emptyView.addSubviews(emptyEmojiLabel, emptyTitleLabel)
        
        setNavBarComponents()
        setContainerViewConstraints()
        setEmptyViewConstraints()
        setEmptyViewComponentsConstraints()
        setTableViewConstraints()
    }
}
//MARK: - UIComponents Constraints
extension FavoriteViewController {
    
    private func setNavBarComponents() {
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(30)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        favoriteTitleLabel.alpha = 0
        UIView.animate(withDuration: 2) {
            self.favoriteTitleLabel.snp.makeConstraints { (make) in
                self.favoriteTitleLabel.alpha = 1
                make.height.equalTo(30)
                make.left.right.equalTo(self.titleView)
                make.top.equalTo(self.titleView.snp.top).offset(10)
            }
        }
    }
    
    private func setContainerViewConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }
    }
    
    private func setEmptyViewConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(70)
            make.left.equalTo(containerView.snp.left).offset(100)
            make.right.equalTo(containerView.snp.right).offset(-100)
            make.height.equalTo(350)
        }
    }
    
    private func setEmptyViewComponentsConstraints() {
        emptyEmojiLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.top)
            make.left.right.equalTo(emptyView)
            make.height.equalTo(100)
        }
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyEmojiLabel.snp.bottom).offset(-80)
            make.left.equalTo(emptyEmojiLabel).offset(-20)
            make.right.equalTo(emptyEmojiLabel).offset(20)
            make.height.equalTo(200)
        }
    }
    
    private func setTableViewConstraints() {
        favoritedMoviesTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(containerView)
        }
    }
}
//MARK: - UITableView Delegate and Datasource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritedMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let favoritedCell = tableView.dequeueReusableCell(withIdentifier: FavoritedMovieTableViewCell.identifier, for: indexPath) as? FavoritedMovieTableViewCell else { return UITableViewCell() }
        if let favoriteMovieObject = favoritedMovies?[indexPath.row] {
            favoritedCell.setFavoritedCell(on: favoriteMovieObject)
        }
        return favoritedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Coordinate.goToDetailViewController(on: favoritedMovies?[indexPath.row], and: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        K.tableViewHeightForRow
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoritedMovies?[indexPath.row].isFavorited = false
            RealmManager().delete(movieObject: favoritedMovies?[indexPath.row])
            NotificationService.setBadgeValue(on: self)
            NotificationService.postNotification(name: K.favoritedNotification, object: favoritedMovies?[indexPath.row].isFavorited)
            fetchFavoritedMovies()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
}
//Tells the favorite vc to dismiss as presentation do not working in viewWillAppear
extension FavoriteViewController: DetailVCOutput {
    func detailVCDismissStatus(state: Bool) {
        if state {
            fetchFavoritedMovies()
            NotificationService.setBadgeValue(on: self)
        }
    }
}

