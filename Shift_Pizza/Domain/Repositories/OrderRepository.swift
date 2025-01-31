//
//  OrderRepository.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 31.01.2025.
//

protocol OrderRepository {
    func payOrder(request: CreatePizzaPaymentDto) async throws -> PizzaPaymentResponse
}
