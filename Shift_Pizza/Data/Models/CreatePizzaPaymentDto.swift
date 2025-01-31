//
//  CreatePizzaPaymentDto.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 31.01.2025.
//

import Foundation

struct CreatePizzaPaymentDto: Codable {
    let receiverAddress: ReceiverAddress
    let person: Person
    let debitCard: DebitCard
    let pizzas: [OrderedPizza]
}

struct ReceiverAddress: Codable {
    let street: String
    let house: String
    let apartment: String
    let comment: String?
}

struct Person: Codable {
    let firstname: String
    let lastname: String
    let middlename: String?
    let phone: String
}

struct DebitCard: Codable {
    let pan: String
    let expireDate: String
    let cvv: String
}

struct OrderedPizza: Codable {
    let id: String
    let name: String
    let toppings: [OrderedPizzaIngredient]
    let size: PizzaSize
    let doughs: PizzaDough
}

struct OrderedPizzaIngredient: Codable {
    let name: String
    let cost: Double
}



