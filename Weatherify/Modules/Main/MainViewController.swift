//
//  MainViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class MainViewController: UITabBarController {

    private lazy var seperator: CALayer = {
        let seperator = CALayer()
        seperator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1)
        seperator.backgroundColor = UIColor.quaternaryLabel.cgColor
        return seperator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .tintColor
        tabBar.unselectedItemTintColor = .darkGray
        tabBar.backgroundColor = .secondarySystemBackground
        tabBar.layer.addSublayer(seperator)
        viewControllers = [
            setupViewController(with: ListRouter().initialViewController,
                                title: "Weatherify",
                                imageName: "house"),
            setupViewController(with: FavouriteRouter().initialViewController,
                                title: "Favourites",
                                imageName: "bookmark")
        ]
    }
    
    private func setupViewController(with rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        rootViewController.tabBarItem.title = title
        rootViewController.tabBarItem.image = UIImage(systemName: imageName)
        rootViewController.title = title
        return UINavigationController(rootViewController: rootViewController)
    }
}
