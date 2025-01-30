//
//  MainViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func navigateToPizzaDetails(pizza: PizzaEntity)
}

class MainViewModel {
    
    weak var delegate: MainViewModelDelegate?
    
    private let getPizzasUseCase: GetPizzasCatalogUseCase
    var pizzas: [Pizza] = []
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    var onPizzasUpdated: (() -> Void)?

    init(getPizzasUseCase: GetPizzasCatalogUseCase = GetPizzasCatalogUseCaseImpl.create()) {
        self.getPizzasUseCase = getPizzasUseCase
    }

    func fetchPizzas() {
        Task {
            do {
                let response = try await getPizzasUseCase.execute()
                pizzas = response.catalog
                onPizzasUpdated?()
            } catch {
                print("Ошибка загрузки пицц: \(error)")
            }
        }
    }
    
    func didSelectPizza(_ pizza: Pizza) {
        print(" Выбрана пицца: \(pizza.name)")
        let pizzaEnt = mapToPizzaEntity(pizza: pizza)
        delegate?.navigateToPizzaDetails(pizza: pizzaEnt)
    }

    private func mapToPizzaEntity(pizza: Pizza) -> PizzaEntity {
        return PizzaEntity(
            id: pizza.id,
            name: pizza.name,
            ingredients: pizza.ingredients.map { PizzaIngredientEntity(name: $0.name, cost: $0.cost, img: $0.img) },
            toppings: pizza.toppings.map { PizzaIngredientEntity(name: $0.name, cost: $0.cost, img: $0.img) },
            description: pizza.description,
            sizes: pizza.sizes.map { PizzaSizeEntity(name: $0.name, price: $0.price) },
            doughs: pizza.doughs.map { PizzaDoughEntity(name: $0.name, price: $0.price) },
            calories: pizza.calories,
            protein: pizza.protein,
            totalFat: pizza.totalFat,
            carbohydrates: pizza.carbohydrates,
            sodium: pizza.sodium,
            allergens: pizza.allergens,
            isVegetarian: pizza.isVegetarian,
            isGlutenFree: pizza.isGlutenFree,
            isNew: pizza.isNew,
            isHit: pizza.isHit,
            img: pizza.img
        )
    }

}

