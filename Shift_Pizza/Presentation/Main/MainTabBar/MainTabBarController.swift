//
//  MainTabBarController.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import UIKit

enum TabBarItem: CaseIterable {
    case main, order, user, cart
    
    var activeIcon: String {
        switch self {
        case .main: return "Pizza_active"
        case .order: return "Time_active"
        case .user: return "User_active"
        case .cart: return "Trash_active"
        }
    }
    
    var inactiveIcon: String {
        switch self {
        case .main: return "Pizza"
        case .order: return "Time"
        case .user: return "User"
        case .cart: return "Trash"
        }
    }
    
    var title: String {
        switch self {
        case .main: return "Главная"
        case .order: return "Заказы"
        case .user: return "Профиль"
        case .cart: return "Корзина"
        }
    }
}

final class MainTabBarController: UITabBarController {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    private lazy var mainViewController: MainViewController = {
        let viewModel = MainViewModel()
        viewModel.delegate = self
        let controller = MainViewController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: TabBarItem.main.title,
            image: UIImage(named: TabBarItem.main.inactiveIcon),
            selectedImage: UIImage(named: TabBarItem.main.activeIcon)
        )
        return controller
    }()
    
    private lazy var orderViewController: OrderViewController = {
        let viewModel = OrderViewModel()
        let controller = OrderViewController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: TabBarItem.order.title,
            image: UIImage(named: TabBarItem.order.inactiveIcon),
            selectedImage: UIImage(named: TabBarItem.order.activeIcon)
        )
        return controller
    }()
    
    private lazy var userViewController: UserViewController = {
        let viewModel = UserViewModel()
        let controller = UserViewController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: TabBarItem.user.title,
            image: UIImage(named: TabBarItem.user.inactiveIcon),
            selectedImage: UIImage(named: TabBarItem.user.activeIcon)
        )
        return controller
    }()
    
    private lazy var cartViewController: ShoppingCartViewController = {
        let viewModel = ShoppingCartViewModel()
        viewModel.delegate = self
        let controller = ShoppingCartViewController(viewModel: viewModel)
        controller.tabBarItem = UITabBarItem(
            title: TabBarItem.cart.title,
            image: UIImage(named: TabBarItem.cart.inactiveIcon),
            selectedImage: UIImage(named: TabBarItem.cart.activeIcon)
        )
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cartViewController = UINavigationController(rootViewController: cartViewController)
        setViewControllers([mainViewController, orderViewController, userViewController, cartViewController], animated: false)
        selectedIndex = 0
        setupTabBarAppearance()
        tabBar.isTranslucent = false
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "White")
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Tertiary")
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "Tertiary")
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Brand")
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "Brand")
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        let border = UIView()
        border.backgroundColor = UIColor(named: "BorderLight")
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        tabBar.addSubview(border)
    }
}


extension MainTabBarController: MainViewModelDelegate, ShoppingCartViewModelDelegate {
    func navigateToPizzaDetails(pizza: PizzaEntity) {
        appRouterDelegate?.navigateToPizzaDetails(pizza: pizza)
    }
    
    func navigateToPersonalData() {
        appRouterDelegate?.navigateToPersonalData()
    }

}

