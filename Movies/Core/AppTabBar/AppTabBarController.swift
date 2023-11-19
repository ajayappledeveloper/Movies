//
//  AppTabBarController.swift
//  Movies
//
//  Created by Ajay Babu Singineedi on 16/11/23.
//  Copyright © 2023 ajay Babu. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
    let appDependencies: AppDependencyFactory
    
    init(dependencies: AppDependencyFactory) {
        self.appDependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBarItems()
    }
    
    func configureTabBarItems() {
        let moviesTab = getMoviesNavController()
        let favouritesTab = getFavouritesNavController()
        self.viewControllers = [moviesTab, favouritesTab]
    }
    
    func getMoviesNavController() -> UINavigationController {
        let movieRepository = MovieRepositoryImpl(dependencies: appDependencies.movieDependencies)
        let moviesVM = MovieViewModel(repository: movieRepository)
        let moviesVC: UIViewController = MoviesViewController(movieViewModel: moviesVM)
        let moviesNavController = UINavigationController(rootViewController: moviesVC)
        moviesNavController.tabBarItem = UITabBarItem(title: AppConstants.AppTabBar.trending, image: UIImage(systemName: ImageNames.trending), selectedImage: UIImage(systemName: ImageNames.tranedingSelected))
        return moviesNavController
    }
    
    func getFavouritesNavController() -> UINavigationController {
        let movieRepository = MovieRepositoryImpl(dependencies: appDependencies.movieDependencies)
        let favouritesVM = FavouritesViewModel(repository: movieRepository)
        let favouritesVC: UIViewController = FavouritesViewController(viewModel: favouritesVM)
        let favouriteNavController = UINavigationController(rootViewController: favouritesVC)
        favouritesVC.tabBarItem = UITabBarItem(title: AppConstants.AppTabBar.favourites, image: UIImage(systemName: ImageNames.favourites), selectedImage: UIImage(systemName: ImageNames.favouritesSelected))
        return favouriteNavController
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
