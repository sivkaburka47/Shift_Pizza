//
//  PizzaDetailsViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import Foundation

class PizzaDetailsViewModel {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    let pizza: PizzaEntity
    var pizzaOrder: OrderedPizza
    var selectedSupplements = Set<String>()
    
    var onTextUpdate: ((String) -> Void)?
    var totalPriceUpdate: ((String) -> Void)?
    
    let ordersKey = "savedPizzaOrders"
    
    init(pizza: PizzaEntity) {
        self.pizza = pizza
        
        let defaultSize = pizza.sizes.first ?? PizzaSizeEntity(name: "SMALL", price: 0)
        let defaultDough = pizza.doughs.first ?? PizzaDoughEntity(name: "THIN", price: 0)
        
        self.pizzaOrder = OrderedPizza(
            id: pizza.id,
            name: pizza.name,
            toppings: [],
            size: OrderedPizzaSize(name: defaultSize.name, price: defaultSize.price),
            doughs: OrderedPizzaDough(name: defaultDough.name, price: defaultDough.price),
            totalPrice: defaultSize.price,
            img: pizza.img
        )
    }
    
    func isSupplementSelected(named name: String) -> Bool {
        return pizzaOrder.toppings.contains { $0.nameInRus == name }
    }

    func toggleSupplementSelection(_ supplement: PizzaIngredientEntity) {
        if let index = pizzaOrder.toppings.firstIndex(where: { $0.name == supplement.name }) {
            pizzaOrder.toppings.remove(at: index)
        } else {
            let orderedSupplement = OrderedPizzaIngredient(name: supplement.name, cost: supplement.cost)
            pizzaOrder.toppings.append(orderedSupplement)
        }
        printPizzaOrder()
        totalPriceUpdate?("В корзину за \(pizzaOrder.totalPrice) ₽")
    }

    
    func updateSize(_ size: String) {
        if let selectedSize = pizza.sizes.first(where: { $0.name == size }) {
            pizzaOrder = OrderedPizza(
                id: pizzaOrder.id,
                name: pizzaOrder.name,
                toppings: pizzaOrder.toppings,
                size: OrderedPizzaSize(name: selectedSize.name, price: selectedSize.price),
                doughs: pizzaOrder.doughs,
                totalPrice: pizzaOrder.totalPrice,
                img: pizzaOrder.img
            )
            onTextUpdate?("\(pizzaOrder.size.sizeInCm), \(pizzaOrder.doughs.doughsInStr)")
        }
        printPizzaOrder()
        totalPriceUpdate?("В корзину за \(pizzaOrder.totalPrice) ₽")
    }
    
    func updateDoughType(_ doughType: String) {
        if let selectedDough = pizza.doughs.first(where: { $0.name == doughType }) {
            pizzaOrder = OrderedPizza(
                id: pizzaOrder.id,
                name: pizzaOrder.name,
                toppings: pizzaOrder.toppings,
                size: pizzaOrder.size,
                doughs: OrderedPizzaDough(name: selectedDough.name, price: selectedDough.price),
                totalPrice: pizzaOrder.totalPrice,
                img: pizzaOrder.img
            )
            onTextUpdate?("\(pizzaOrder.size.sizeInCm), \(pizzaOrder.doughs.doughsInStr)")
        }
        printPizzaOrder()
        totalPriceUpdate?("В корзину за \(pizzaOrder.totalPrice) ₽")
    }
    
    private func printPizzaOrder() {
        let toppingsCost = pizzaOrder.toppings.reduce(0) { $0 + $1.cost }
        pizzaOrder.totalPrice = pizzaOrder.size.price + pizzaOrder.doughs.price + toppingsCost

        print("Текущий заказ:")
        print("ID: \(pizzaOrder.id)")
        print("Название: \(pizzaOrder.name)")
        print("Размер: \(pizzaOrder.size.name) (\(pizzaOrder.size.price) ₽)")
        print("Тесто: \(pizzaOrder.doughs.name) (\(pizzaOrder.doughs.price) ₽)")
        print("Доп. ингредиенты:")
        
        if pizzaOrder.toppings.isEmpty {
            print("- Нет дополнительных ингредиентов")
        } else {
            for topping in pizzaOrder.toppings {
                print("- \(topping.name) (\(topping.cost) ₽)")
            }
        }
        
        print("Общая стоимость: \(pizzaOrder.totalPrice) ₽")
        print("------")
    }
    
    func saveOrderToUserDefaults() {
        let defaults = UserDefaults.standard
        var savedOrders = loadOrdersFromUserDefaults()

        savedOrders.append(pizzaOrder)

        if let encodedData = try? JSONEncoder().encode(savedOrders) {
            defaults.set(encodedData, forKey: ordersKey)
        }

        appRouterDelegate?.dismissPresentedViewController()
    }


    private func calculateTotalPrice(_ order: OrderedPizza) -> Int {
        let toppingsCost = order.toppings.reduce(0) { $0 + $1.cost }
        return order.size.price + order.doughs.price + toppingsCost
    }


    func loadOrdersFromUserDefaults() -> [OrderedPizza] {
        let defaults = UserDefaults.standard

        if let savedData = defaults.data(forKey: ordersKey),
           let decodedOrders = try? JSONDecoder().decode([OrderedPizza].self, from: savedData) {
            return decodedOrders
        }
        
        return []
    }

}
