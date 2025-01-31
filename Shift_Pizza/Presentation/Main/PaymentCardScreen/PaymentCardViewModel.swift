//
//  PaymentCardViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import Foundation

class PaymentCardViewModel {
    weak var appRouterDelegate: AppRouterDelegate?
    init() {
        
    }
    
    func confirmButtonTapped() {
        appRouterDelegate?.navigateToPaymentCard()
    }
}
