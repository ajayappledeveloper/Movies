//
//  ViewController.swift
//  Movies
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class MoviesViewController: BaseViewController {
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.center = self.view.center
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self

        view.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        return view
    }()
    
    
    var movieViewModel: MovieViewModel
    
    init(movieViewModel: MovieViewModel) {
        self.movieViewModel = movieViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSubviews()
        fetchMovies()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        self.title = AppConstants.Movies.title
    }
    
    override func configureSubviews() {
        view.addSubview(movieCollectionView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            movieCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    func fetchMovies() {
        activityIndicatorView.startAnimating()
        movieViewModel.fetchMovies { (movies, error) in
            guard let _ = movies else {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    @objc func favouriteButtonTapped(sender: UIButton) {
        let movie = movieViewModel.movies[sender.tag]
        movieViewModel.updateFavouriteStatus(for: movie) { (success) in
            if(success) {
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
                }
            }
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCollectionViewCell
        guard let movieCell = cell else {
            return UICollectionViewCell()
        }
        let movie = movieViewModel.movies[indexPath.row]
        cell?.configureCell(with: movie)
        
        cell?.favouriteButton.tag = indexPath.row
        movieViewModel.checkFavourite(for: movie.originalTitle) { (isFavourite) in
            DispatchQueue.main.async {
                cell?.favouriteButton.setImage(isFavourite ? UIImage(systemName: ImageNames.favouritesSelected) : UIImage(systemName: ImageNames.favourites), for: .normal)
            }
        }
        cell?.favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped(sender:)), for: .touchUpInside)
        return movieCell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/2 - 20, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selecteMovieId: Int = movieViewModel.movies[indexPath.row].id
        let viewModel = MovieDetailViewModel(repository: movieViewModel.repository, id: selecteMovieId)
        let movieDetailsVC = MovieDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }

}

extension MoviesViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let indexPath = indexPaths.first {
            if indexPath.row > movieViewModel.movies.count - 4 {
                if(movieViewModel.currentPage == movieViewModel.totalPages) {
                    print("No more movies...")
                } else {
                    fetchMovies()
                }
            }
        }
    }
}
