//
//  PizzasEntity.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import Foundation

struct PizzasEntity {
    let success: Bool
    let reason: String?
    let catalog: [PizzaEntity]
}

struct PizzaEntity {
    let id: String
    let name: String
    let ingredients: [PizzaIngredientEntity]
    let toppings: [PizzaIngredientEntity]
    let description: String
    let sizes: [PizzaSizeEntity]
    let doughs: [PizzaDoughEntity]
    let calories: Double
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

enum PizzaIngredientEntity: String {
    case pineapple = "PINEAPPLE"
    case mozzarella = "MOZZARELLA"
    case peperoni = "PEPERONI"
    case greenPepper = "GREEN_PEPPER"
    case mushrooms = "MUSHROOMS"
    case basil = "BASIL"
    case cheddar = "CHEDDAR"
    case parmesan = "PARMESAN"
    case feta = "FETA"
    case ham = "HAM"
    case pickle = "PICKLE"
    case tomato = "TOMATO"
    case bacon = "BACON"
    case onion = "ONION"
    case chile = "CHILE"
    case shrimps = "SHRIMPS"
    case chickenFillet = "CHICKEN_FILLET"
    case meatballs = "MEATBALLS"
}

enum PizzaSizeEntity: String {
    case small = "SMALL"
    case medium = "MEDIUM"
    case large = "LARGE"
}

enum PizzaDoughEntity: String {
    case thin = "THIN"
    case thick = "THICK"
}

