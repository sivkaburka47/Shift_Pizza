//
//  PizzaPaymentResponse.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 31.01.2025.
//

import Foundation

struct PizzaPaymentResponse: Codable {
    let success: Bool
    let reason: String?
    let order: PaymentResponse
}

struct PaymentResponse: Codable {
    let pizzas: [OrderedPizza]
    let person: Person
    let receiverAddress: ReceiverAddress
    let status: Int
    let cancellable: Bool
}
