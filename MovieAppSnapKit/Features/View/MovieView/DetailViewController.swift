//
//  DetailViewController.swift
//  MovieAppSnapKit
//
//  Created by Emirhan on 1.10.2021.
//

import UIKit
import SafariServices
import WebKit

protocol DetailVCOutput: NSObject {
    func detailVCDismissStatus(state: Bool)
}

protocol DetailViewControllerOutput {
    func fetchCast(results: [Cast])
    func fetchTrailers(results: [Video])
}

class DetailViewController: UIViewController {
    
    private let containerView = UIView()
    
    private let movieImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let trailerButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.layer.cornerRadius = 0.4 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor.red.cgColor
        button.setImage(UIImage(named: "play"), for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var trailerView: WKWebView = {
        let webView = WKWebView(frame: movieImageView.bounds, configuration: WKWebViewConfiguration())
        webView.layer.cornerRadius = 15
        webView.layer.masksToBounds = true
        webView.contentMode = .scaleAspectFill
        webView.isHidden = true
        return webView
    }()

    private let movieTitle: UILabel = {
        let title = UILabel()
        title.font = Styling.font(fontName: .helvetica, weight: .bold, size: 18)
        title.numberOfLines = 0
        title.textColor = Styling.colorForCode(.black)
        title.backgroundColor = .clear
        return title
    }()
    
    private lazy var movieOverviewTitle: UILabel = {
        let title = UILabel()
        title.font = Styling.font(fontName: .helvetica, weight: .bold, size: 16)
        title.numberOfLines = 0
        title.textColor = Styling.colorForCode(.black)
        title.text = "Overview"
        title.backgroundColor = .clear
        self.view.addSubview(title)
        return title
    }()
    
    private let movieOverview: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textColor = Styling.colorForCode(.black)
        textView.font = Styling.font(fontName: .helvetica, weight: .semibold, size: 14)
        return textView
    }()
    
    private let movieRateLabel: UILabel = {
        let title = UILabel()
        title.font = Styling.font(fontName: .helvetica, weight: .medium, size: 16)
        title.textAlignment = .right
        title.numberOfLines = 0
        title.textColor = Styling.colorForCode(.black)
        title.backgroundColor = .clear
        return title
    }()
    
    private let movieReleaseDate: UILabel = {
        let title = UILabel()
        title.font = Styling.font(fontName: .helvetica, weight: .regular, size: 15)
        title.textAlignment = .right
        title.numberOfLines = 0
        title.textColor = .black
        title.backgroundColor = .clear
        return title
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 160, width: 80, height: 100)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor.red.cgColor
        button.setImage(UIImage(named: "Shape"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    private lazy var castTitle: UILabel = {
        let title = UILabel()
        title.font = Styling.font(fontName: .helvetica, weight: .bold, size: 16)
        title.numberOfLines = 0
        title.textColor = Styling.colorForCode(.black)
        title.text = "Cast"
        title.backgroundColor = .clear
        self.view.addSubview(title)
        return title
    }()
    
    private lazy var castCollectionView: UICollectionView = {
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
    
    private let likeView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Favori")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    var movieObject: Movie?
    private lazy var castsObject = [Cast]()
    private lazy var trailerVideo = [Video]()
    weak var delegate: DetailVCOutput?
    private lazy var viewModel = DetailViewModel()
    var isMovieFavorited: Bool = false {
        didSet {
            isMovieFavorited ? favoriteButton.setImage(UIImage(named: "Favori"), for: .normal) : favoriteButton.setImage(UIImage(named: "Shape"), for: .normal)
        }
    }
    var isTrailerTapped: Bool = false {
        didSet {
            isTrailerTapped ? trailerButton.setImage(UIImage(named: "pause-button"), for: .normal) : trailerButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.setDelegates(output: self)
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setComponentDatas(model: movieObject)
        viewModel.fetchCast(movieID: movieObject?.id ?? 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.detailVCDismissStatus(state: true)
    }
    
    private func setComponentDatas(model: Movie?) {
        if let model = model {
            movieImageView.fetchImage(from: model.backdropStr ?? "")
            movieTitle.text = model.title ?? ""
            movieOverview.text = model.overview ?? ""
            movieReleaseDate.text = "🎥: \(model.releaseDate ?? "")"
            isMovieFavorited = model.isFavorited ? true : false
            let movieRateDouble: Double = model.rate ?? 0.0
            let movieRateInt: Int = Int(model.rate ?? 0.0)
            switch movieRateInt {
            case 8...10:
                movieRateLabel.text = "\(String(movieRateDouble)) ⭐️⭐️⭐️⭐️⭐️"
            case 6...8:
                movieRateLabel.text = "\(String(movieRateDouble)) ⭐️⭐️⭐️⭐️"
            case 4...6:
                movieRateLabel.text = "\(String(movieRateDouble)) ⭐️⭐️⭐️"
            case 2...4:
                movieRateLabel.text = "\(String(movieRateDouble)) ⭐️⭐️"
            case 1...2:
                movieRateLabel.text = "\(String(movieRateDouble)) ⭐️"
            default:
                movieRateLabel.text = "No rate given"
            }
        } else {
            view.alpha = 0
        }
    }
    
    @objc private func playButtonPressed() {
        isTrailerTapped.toggle()
        if isTrailerTapped {
            movieImageView.isHidden = true
            trailerView.isHidden = false
            viewModel.fetchTrailers(movieID: movieObject?.id ?? 0)
        } else {
            trailerView.isHidden = true
            movieImageView.isHidden = false
        }
    }
    
    @objc private func favoriteButtonPressed() {
        isMovieFavorited.toggle()
        view.addSubviews(likeView)
        if isMovieFavorited {
            movieObject?.isFavorited = true
            RealmManager().save(on: movieObject)
            Animate.addAnimation(on: likeView, and: self)
        } else {
            movieObject?.isFavorited = false
            RealmManager().delete(movieObject: movieObject)
            likeView.removeFromSuperview()
        }
        NotificationService.postNotification(name: "isFavorited", object: movieObject?.isFavorited)
    }
    
    private func configureUI() {
        view.backgroundColor = Styling.colorForCode(.moreLighterGray)
        view.addSubview(containerView)
        containerView.addSubviews(movieImageView, trailerView, trailerButton, movieTitle, movieRateLabel, movieOverview, movieReleaseDate, favoriteButton, castCollectionView, castTitle)
        setContainerViewComponentsConstraints()
        setFavoriteButtonConstraints()
        setFavButtonUI()
    }
}
//MARK: - UIComponents Constraints
extension DetailViewController {
    func setContainerViewComponentsConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        movieImageView.alpha = 0.8
        movieImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(30)
            make.left.equalTo(containerView.snp.left).offset(10)
            make.right.equalTo(containerView.snp.right).offset(-10)
            make.height.equalTo(200)
        }
        
        trailerView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(30)
            make.left.equalTo(containerView.snp.left).offset(10)
            make.right.equalTo(containerView.snp.right).offset(-10)
            make.height.equalTo(175)
        }
        
        trailerButton.snp.makeConstraints { make in
            make.bottom.equalTo(movieImageView.snp.bottom)
            make.left.equalTo(movieImageView.snp.left)
            make.height.width.equalTo(60)
        }
        
        movieTitle.snp.makeConstraints { make in
            make.left.equalTo(movieImageView.snp.left)
            make.right.equalTo(containerView.snp.right).offset(-view.frame.width / 2.5)
            make.top.equalTo(movieImageView.snp.bottom).offset(20)
            make.height.lessThanOrEqualTo(100)
        }
        
        movieOverviewTitle.snp.makeConstraints { make in
            make.left.equalTo(movieTitle.snp.left)
            make.right.equalTo(movieTitle.snp.right)
            make.top.equalTo(movieTitle.snp.bottom).offset(10)
            make.height.lessThanOrEqualTo(100)
        }
        
        movieRateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.top)
            make.right.equalTo(containerView.snp.right).offset(-10)
            make.left.equalTo(movieTitle.snp.right)
            make.height.lessThanOrEqualTo(100)
        }
        
        movieOverview.snp.makeConstraints { make in
            make.left.equalTo(movieImageView.snp.left)
            make.right.equalTo(movieImageView.snp.right)
            make.top.equalTo(movieOverviewTitle.snp.bottom)
            make.height.equalTo(100)
        }
        
        movieReleaseDate.snp.makeConstraints { make in
            make.right.equalTo(movieOverview.snp.right)
            make.top.equalTo(movieOverviewTitle.snp.top)
            make.height.equalTo(movieOverviewTitle.snp.height)
            make.width.lessThanOrEqualTo(200)
        }
        
        castTitle.snp.makeConstraints { make in
            make.left.equalTo(movieOverviewTitle.snp.left)
            make.right.equalTo(movieImageView.snp.right)
            make.height.lessThanOrEqualTo(100)
            make.top.equalTo(movieOverview.snp.bottom).offset(5)
        }
        
        castCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(movieImageView)
            make.top.equalTo(castTitle.snp.bottom).offset(10)
            make.height.equalTo(200)
        }
    }
    
    func setFavoriteButtonConstraints() {
        favoriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-60)
            make.right.equalToSuperview().offset(-50)
            make.height.width.equalTo(80)
        }
    }
    
    private func setFavButtonUI() {
        favoriteButton.setImage(UIImage(named: "Shape"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.imageView?.snp.makeConstraints({ make in
            make.width.height.equalTo(50)
            make.top.equalTo(favoriteButton.snp.top)
            make.bottom.equalTo(favoriteButton.snp.bottom)
        })
    }
}
//MARK: - UICollectionView Delegate
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        castsObject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        castCell.setMovieImage(on: castsObject[indexPath.row].profileStr,
                               contentMode: .scaleAspectFill,
                               title: castsObject[indexPath.row].name)
        return castCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedCastID = castsObject[indexPath.row].id ?? 0
        if let url = URL(string: "\(getURL(on: .castTMDBPage))\(selectedCastID)") {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .popover
            safariVC.modalTransitionStyle = .crossDissolve
            present(safariVC, animated: true)
        }
    }
}
//MARK: - UICollectionView FlowLayoutDelegate
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 75, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
//MARK: - DetailVC Output
extension DetailViewController: DetailViewControllerOutput {
    func fetchTrailers(results: [Video]) {
        self.trailerVideo = results
        if let url = URL(string: "https://www.youtube.com/watch?v=\(self.trailerVideo.first?.key ?? "" )?playsinline=1") {
            DispatchQueue.main.async { [weak self] in
                self?.trailerView.load(URLRequest(url: url))
            }
        }
    }
    
    func fetchCast(results: [Cast]) {
        self.castsObject.append(contentsOf: results)
        DispatchQueue.main.async { [weak self] in
            self?.castCollectionView.reloadData()
        }
    }
}
