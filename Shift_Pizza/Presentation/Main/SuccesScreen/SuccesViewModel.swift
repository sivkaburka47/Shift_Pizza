//
//  SuccesViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 01.02.2025.
//

import Foundation
import UIKit

class SuccesViewModel {
    weak var appRouterDelegate: AppRouterDelegate?
    weak var uiViewController: UIViewController?
    let address: ReceiverAddressEntity
    var orders: [OrderedPizzaEntity] = []
    var totalPrice: Int = 0
    
    init(address: ReceiverAddressEntity) {
        self.address = address
        loadOrders()
        calculateTotal()
    }
    
    private func loadOrders() {
        guard let data = UserDefaults.standard.data(forKey: "savedPizzaOrders") else { return }
        orders = (try? JSONDecoder().decode([OrderedPizzaEntity].self, from: data)) ?? []
        UserDefaults.standard.removeObject(forKey: "savedPizzaOrders")
        UserDefaults.standard.synchronize() 
    }
    
    private func calculateTotal() {
        totalPrice = orders.reduce(0) { $0 + $1.totalPrice * $1.quantity}
    }
    
    func navigateToMain() {
        appRouterDelegate?.navigateToMain()
    }
}
