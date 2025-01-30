//
//  ShoppingCartViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import Foundation

class ShoppingCartViewModel {
    
    private(set) var orders: [OrderedPizza] = []
    
    var onCartUpdated: (() -> Void)?
    
    init() {
        loadOrders()
    }
    
    func getOrders() -> [OrderedPizza] {
        return orders
    }
    
    func loadOrders() {
        guard let data = UserDefaults.standard.data(forKey: "savedPizzaOrders") else {
            print("Нет данных в UserDefaults")
            orders = []
            return
        }
        
        do {
            let decodedOrders = try JSONDecoder().decode([OrderedPizza].self, from: data)
            orders = decodedOrders
            print("Загруженные заказы: \(orders)")
        } catch {
            print("Ошибка декодирования: \(error)")
            orders = []
        }
    }

    
    private func saveOrders() {
        if let encodedData = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(encodedData, forKey: "savedPizzaOrders")
        }
    }
    
    func increaseQuantity(at index: Int) {
        guard index < orders.count else { return }
        orders[index].quantity += 1
        saveOrders()
        onCartUpdated?()
    }

    func decreaseQuantity(at index: Int) {
        guard index < orders.count else { return }
        
        if orders[index].quantity > 1 {
            orders[index].quantity -= 1
        } else {
            orders.remove(at: index)
        }
        
        saveOrders()
        onCartUpdated?()
    }
    
    func editPizza(at index: Int) {
        // Заглушка: будет реализовано позже
    }

}
