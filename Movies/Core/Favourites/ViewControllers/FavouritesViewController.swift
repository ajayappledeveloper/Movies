//
//  FavouritesViewController.swift
//  Movies
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import UIKit

class FavouritesViewController: BaseViewController {
    
    lazy var favouriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        return view
    }()
    
    lazy var zeroTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = AppConstants.Favourites.zeroText
        return label
    }()
    
    var favouritesViewModel: FavouritesViewModel
    
    init(viewModel: FavouritesViewModel) {
        self.favouritesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureAppearance()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavourites()
    }
    
    func fetchFavourites() {
        favouritesViewModel.getFavourites {[weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if(self.favouritesViewModel.favourites.isEmpty) {
                    self.favouriteCollectionView.isHidden = true
                    self.zeroTextLabel.isHidden = false
                } else {
                    self.favouriteCollectionView.isHidden = false
                    self.zeroTextLabel.isHidden = true
                    self.favouriteCollectionView.reloadData()
                }
            }
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        self.title = AppConstants.Favourites.title
    }
    
    override func configureSubviews() {
        view.addSubview(favouriteCollectionView)
        view.addSubview(zeroTextLabel)
        
        NSLayoutConstraint.activate([
            favouriteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouriteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favouriteCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            favouriteCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    
        zeroTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        zeroTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        zeroTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        zeroTextLabel.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
}

extension FavouritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouritesViewModel.favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favouriteCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCollectionViewCell
        guard let movieCell = cell else {
            return UICollectionViewCell()
        }
        let movie = favouritesViewModel.favourites[indexPath.row]
        cell?.configureCell(with: movie)
        cell?.favouriteButton.isHidden = true
        return movieCell
    }
}


extension FavouritesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/2 - 20, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selecteMovieId: Int = favouritesViewModel.favourites[indexPath.row].id
        guard let appDependencies = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appDependencies else { return }
        let repository = MovieRepositoryImpl(dependencies: appDependencies.movieDependencies)
        let viewModel = MovieDetailViewModel(repository: repository, id: selecteMovieId)
        let movieDetailsVC = MovieDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
