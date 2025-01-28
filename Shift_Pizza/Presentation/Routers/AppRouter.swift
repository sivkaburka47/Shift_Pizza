//
//  AppRouter.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import UIKit

class AppRouter {

    private let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func navigateToMain() {
        let mainViewModel = MainViewModel()
        let viewController = MainViewController(viewModel: mainViewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
