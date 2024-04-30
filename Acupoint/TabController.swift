import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        
        overrideUserInterfaceStyle = .light

        // 設置tabBar的appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear

        // 將陰影設置為nil
        appearance.shadowColor = nil
        appearance.shadowImage = nil

        // 設置standardAppearance和scrollEdgeAppearance
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance

        // 設置選中和未選中的圖片顏色
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .lightGray

        // 設置tabBar的背景色為透明
//        self.tabBar.barTintColor = .clear
        self.tabBar.backgroundColor = .backgroundColor
                
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
        
//        navigation.viewControllers.first?.navigationItem.title = title
        
        
        // 調整未選中圖片的大小
        if let unselectedImage = unselectedImage {
            let size = CGSize(width: 36, height: 36) // 設置所需的大小
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            unselectedImage.draw(in: CGRect(origin: .zero, size: size))
            let resizedUnselectedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            navigation.tabBarItem.image = resizedUnselectedImage
        }
        
        // 調整選中圖片的大小
        if let selectedImage = selectedImage {
            let size = CGSize(width: 36, height: 36) // 設置所需的大小
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
