//
//  AppRouter.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import UIKit

protocol AppRouterDelegate: AnyObject {
    func navigateToSignIn()
    func navigateToMain()
}

final class AppRouter: AppRouterDelegate {
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let signInViewController = createSignInViewController()
        window?.rootViewController = signInViewController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Navigation Methods
extension AppRouter {
    
    func navigateToSignIn() {
        let signInViewController = createSignInViewController()
        transition(to: signInViewController)
    }
    
    func navigateToMain() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let mainTabBarController = self.createMainTabBarController()
            self.transition(to: mainTabBarController)
        }
    }
}

// MARK: - ViewController Creation
extension AppRouter {
    
    private func createSignInViewController() -> UINavigationController {
        let signInViewModel = SignInViewModel()
        signInViewModel.appRouterDelegate = self
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        return UINavigationController(rootViewController: signInViewController)
    }

    
    private func createMainTabBarController() -> MainTabBarController {
        let mainTabBarController = MainTabBarController()
        return mainTabBarController
    }
    
    private func transition(to viewController: UIViewController) {
        guard let window = self.window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}


