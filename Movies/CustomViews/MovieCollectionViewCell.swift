//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by ajay Babu on 17/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieCollectionViewCell.self)
    
    lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var movieTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.numberOfLines = 2
        view.lineBreakMode = .byTruncatingMiddle
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return view
    }()
    
    lazy var movieRatingLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return view
    }()
    
    lazy var favouriteButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: ImageNames.favourites), for: .normal)
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return view
    }()
    
    lazy var ratingHStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [movieRatingLabel, favouriteButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(ratingHStack)
        
        //Poster Image View Constraints
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        //Movie Title Label Constraints
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            movieTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 12),
            movieTitleLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -12),
        ])
        
        //Rating HStack Constraints
        NSLayoutConstraint.activate([
            ratingHStack.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 0),
            ratingHStack.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor, constant: 12),
            ratingHStack.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor, constant: -12),
            ratingHStack.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureCell(with movie: Movie) {
        self.movieTitleLabel.text = movie.originalTitle
        self.movieRatingLabel.text = "Rate: \(movie.rating)"
        if let posterURL = movie.posterURL {
            self.posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: ImageNames.placeholderImage))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        movieTitleLabel.text = nil
        movieRatingLabel.text = nil
        favouriteButton.setImage(UIImage(systemName: ImageNames.favourites), for: .normal)
    }

}
