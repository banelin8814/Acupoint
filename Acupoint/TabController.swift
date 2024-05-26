import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var alertView = AlertView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.view.addSubview(alertView)
        }
        overrideUserInterfaceStyle = .light

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = nil
        appearance.shadowImage = nil

        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.backgroundColor = .backgroundColor
        
        self.setupTabs()
    }

    private func setupTabs() {
        let homePage = self.createNav(with: "",
                                      selectedImage: UIImage(named: "UI_家黑色"),
                                      unselectedImage: UIImage(named: "UI_家灰色"),
                                      viewController: HomeVC())

        let searchPage = self.createNav(with: "",
                                        selectedImage: UIImage(named: "UI_手黑色"),
                                        unselectedImage: UIImage(named: "UI_手灰色"),
                                        viewController: SearchVC())

        let wikiPage = self.createNav(with: "",
                                      selectedImage: UIImage(named: "UI_書黑色"),
                                      unselectedImage: UIImage(named: "UI_書灰色"),
                                      viewController: WikiVC())

        self.setViewControllers([homePage, searchPage, wikiPage], animated: true)
    }

    private func createNav(with title: String,
                           selectedImage: UIImage?,
                           unselectedImage: UIImage?,
                           viewController: UIViewController) -> UINavigationController {
        
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.tintColor = .white
        navigation.tabBarItem.title = title
        
        if let unselectedImage = unselectedImage {
            let size = CGSize(width: 45, height: 45)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            unselectedImage.draw(in: CGRect(origin: .zero, size: size))
            let resizedUnselectedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            navigation.tabBarItem.image = resizedUnselectedImage
        }
        
        if let selectedImage = selectedImage {
            let size = CGSize(width: 45, height: 45) 
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            selectedImage.draw(in: CGRect(origin: .zero, size: size))
            let resizedSelectedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            navigation.tabBarItem.selectedImage = resizedSelectedImage
        }
            
        navigation.viewControllers.first?.navigationItem.title = title
        return navigation
    }
}


