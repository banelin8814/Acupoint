//
//  TabVC.swift
//  Acupoint
//
//  Created by 林佑淳 on 2024/4/16.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .systemGray3
        
        // 將標籤列設置為毛玻璃效果
             let tabBarAppearance = UITabBarAppearance()
             tabBarAppearance.configureWithTransparentBackground()
             tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
             self.tabBar.standardAppearance = tabBarAppearance
             if #available(iOS 15.0, *) {
                 self.tabBar.scrollEdgeAppearance = tabBarAppearance
             }
    }
    
    
    private func setupTabs() {
        let homePage = self.createNav(with: "Home", and: UIImage(systemName: "house"), viewController: HomeVC())
        let searchPage = self.createNav(with: "search", and: UIImage(systemName: "magnifyingglass"), viewController: SearchVC())
        self.setViewControllers([homePage, searchPage], animated: true)

    }

    private func createNav(with title: String, 
                           and image: UIImage?,
                           viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)

        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = image
        navigation.viewControllers.first?.navigationItem.title = title
                
        return navigation
    }
}
