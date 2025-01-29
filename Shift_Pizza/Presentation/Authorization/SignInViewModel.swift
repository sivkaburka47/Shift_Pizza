//
//  SignInViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import Foundation


class SignInViewModel {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    init() {}
    
    func signIn() {
        appRouterDelegate?.navigateToMain()
    }
}
