//
//  PizzasResponse.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import Foundation

struct PizzasResponse: Codable {
    let success: Bool
    let reason: String?
    let catalog: [Pizza]
}

struct Pizza: Codable {
    let id: String
    let name: String
    let ingredients: [PizzaIngredient]
    let toppings: [PizzaIngredient]
    let description: String
    let sizes: [PizzaSize]
    let doughs: [PizzaDough]
    let calories: Int
    let protein: String
    let totalFat: String
    let carbohydrates: String
    let sodium: String
    let allergens: [String]
    let isVegetarian: Bool
    let isGlutenFree: Bool
    let isNew: Bool
    let isHit: Bool
    let img: String
}

struct PizzaIngredient: Codable {
    let name: String
    let cost: Int
    let img: String
}

struct PizzaSize: Codable {
    let name: String
    let price: Int
}

struct PizzaDough: Codable {
    let name: String
    let price: Int
}
