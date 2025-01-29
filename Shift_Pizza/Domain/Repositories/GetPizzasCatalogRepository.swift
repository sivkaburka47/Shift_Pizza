//
//  GetPizzasCatalogRepository.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

protocol GetPizzasCatalogRepository {
    func getPizzas() async throws -> PizzasResponse
}
