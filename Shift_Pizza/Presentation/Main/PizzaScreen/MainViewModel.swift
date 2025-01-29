//
//  MainViewModel.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 28.01.2025.
//

import Foundation

class MainViewModel {
    
    private let getPizzasUseCase: GetPizzasCatalogUseCase
    var pizzas: [Pizza] = []
    
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
}

