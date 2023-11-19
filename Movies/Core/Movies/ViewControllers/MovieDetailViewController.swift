//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 18/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import UIKit

class MovieDetailViewController: BaseViewController {
    
    var movieDetailViewModel: MovieDetailViewModel
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, genreLabel, infoLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 4
        view.lineBreakMode = .byTruncatingMiddle
        view.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        return view
    }()
    
    lazy var genreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byTruncatingMiddle
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byTruncatingMiddle
        view.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 750).isActive = true
        return view
    }()
    
    lazy var synopsysLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 0
        view.lineBreakMode = .byTruncatingMiddle
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return view
    }()
    
    init(viewModel: MovieDetailViewModel) {
        self.movieDetailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSubviews()
        
        movieDetailViewModel.fetchMovieDetails(for: movieDetailViewModel.id) {[weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.titleLabel.text = self.movieDetailViewModel.title
                    self.genreLabel.text = self.movieDetailViewModel.genre
                    self.infoLabel.text = self.movieDetailViewModel.info
                    self.synopsysLabel.text = self.movieDetailViewModel.synopsis
                    guard let posterURL = self.movieDetailViewModel.posterURL else { return }
                    self.imageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: ImageNames.placeholderImage))
                }
            } else {
                if let error = movieDetailViewModel.errorMessage, error == "Offline" {
                    self.presentOfflineAlert()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1100)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        self.title = AppConstants.MovieDetails.title
    }
    
    override func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(synopsysLabel)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant:  -20),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 120),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            synopsysLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            synopsysLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            synopsysLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
        ])
        
    }
    
    func presentOfflineAlert() {
        let alert = UIAlertController(title: "Offline Error", message: "You are not connected to internet. Please connect and retry.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
