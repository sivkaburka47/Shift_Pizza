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
    func navigateToPizzaDetails(pizza: PizzaEntity)
    func dismissPresentedViewController()
    func navigateToPersonalData(vc: UIViewController)
    func navigateToPaymentCard(vc: UIViewController, person: PersonEntity, address: ReceiverAddressEntity)
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
    
    func navigateToPizzaDetails(pizza: PizzaEntity) {
        let pizzaDetailsViewController = createPizzaDetailsViewController(pizza: pizza)
        let navigationController = UINavigationController(rootViewController: pizzaDetailsViewController)
        navigationController.modalPresentationStyle = .fullScreen
        setupNavigationBar(for: pizzaDetailsViewController, title: "Пицца", isPresent: true)
        guard let viewController = window?.rootViewController else { return }
        viewController.present(navigationController, animated: true)
        
    }
    
    func navigateToPersonalData(vc: UIViewController) {
        let pesonalDataViewController = createPersonalDataViewController()
//        guard let navigationController = (window?.rootViewController as? UITabBarController)?
//            .selectedViewController as? UINavigationController else { return }
        setupNavigationBar(for: pesonalDataViewController, title: "Ваши данные", isPresent: false)
        vc.navigationController?.pushViewController(pesonalDataViewController, animated: true)
    }
    
    func navigateToPaymentCard(vc: UIViewController, person: PersonEntity, address: ReceiverAddressEntity) {
        let paymentCardViewController = createPaymentCardViewController(person: person, address: address)
//        guard let navigationController = (window?.rootViewController as? UITabBarController)?
//            .selectedViewController as? UINavigationController else { return }
        setupNavigationBar(for: paymentCardViewController, title: "Карта оплаты", isPresent: false)
        vc.navigationController?.pushViewController(paymentCardViewController, animated: true)
    }
    
    func dismissPresentedViewController() {
        guard let viewController = window?.rootViewController?.presentedViewController else { return }
        viewController.dismiss(animated: true)
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
    
    
    private func createPizzaDetailsViewController(pizza: PizzaEntity) -> PizzaDetailsViewController {
        let pizzaDetailsViewModel = PizzaDetailsViewModel(pizza: pizza)
        pizzaDetailsViewModel.appRouterDelegate = self
        let pizzaDetailsViewController = PizzaDetailsViewController(viewModel: pizzaDetailsViewModel)
        return pizzaDetailsViewController
    }
    
    
    
    private func createPersonalDataViewController() -> PersonalDataViewController {
        let personalDataViewModel = PersonalDataViewModel()
        personalDataViewModel.appRouterDelegate = self
        let personalDataViewController = PersonalDataViewController(viewModel: personalDataViewModel)
        personalDataViewModel.uiViewController = personalDataViewController
        
        return personalDataViewController
    }
    
    private func createPaymentCardViewController(person: PersonEntity, address: ReceiverAddressEntity) -> PaymentCardViewController {
        let paymentCardViewModel = PaymentCardViewModel(person: person,  address: address)
        paymentCardViewModel.appRouterDelegate = self
        let paymentCardViewController = PaymentCardViewController(viewModel: paymentCardViewModel)
        paymentCardViewModel.uiViewController = paymentCardViewController
        return paymentCardViewController
    }

    
    private func createMainTabBarController() -> MainTabBarController {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.appRouterDelegate = self
        return mainTabBarController
    }
    
}


// MARK: - Navigation Bar Setup
extension AppRouter {
    
    private func navigateToViewController(_ viewController: UIViewController, title: String) {
        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
        setupNavigationBar(for: viewController, title: title)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupNavigationBar(for viewController: UIViewController, title: String, isPresent: Bool = false) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "Primary")!,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        viewController.navigationController?.navigationBar.standardAppearance = appearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        viewController.navigationController?.navigationBar.compactAppearance = appearance
        
        viewController.navigationController?.navigationBar.isTranslucent = false
        viewController.navigationItem.hidesBackButton = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor(named: "Primary")
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .large)), for: .normal)
        
        backButton.tintColor = UIColor(named: "IndicatorLight")
        
        if isPresent {
            backButton.addTarget(self, action: #selector(backButtonTappedPresented), for: .touchUpInside)
        } else {
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 24
        
        viewController.navigationItem.leftBarButtonItems = [
            backBarButtonItem,
            spacer,
            UIBarButtonItem(customView: titleLabel)
        ]
    }

    
//    @objc private func backButtonTapped() {
//        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
//        navigationController.popViewController(animated: true)
//    }
    
    @objc private func backButtonTapped() {
        guard let navigationController = (window?.rootViewController as? UITabBarController)?
            .selectedViewController as? UINavigationController else { return }
        
        navigationController.popViewController(animated: true)
    }

    
    @objc private func backButtonTappedPresented() {
        guard let viewController = window?.rootViewController else { return }
        viewController.dismiss(animated: true)
    }
    
    private func transition(to viewController: UIViewController) {
        guard let window = self.window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}
