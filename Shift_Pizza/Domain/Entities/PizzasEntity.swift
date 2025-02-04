//
//  PizzasResponse.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

import Foundation

struct PizzasEntity: Codable {
    let success: Bool
    let reason: String?
    let catalog: [PizzaEntity]
}

struct PizzaEntity: Codable {
    let id: String
    let name: String
    let ingredients: [PizzaIngredientEntity]
    let toppings: [PizzaIngredientEntity]
    let description: String
    let sizes: [PizzaSizeEntity]
    let doughs: [PizzaDoughEntity]
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

struct PizzaIngredientEntity: Codable {
    let name: String
    let cost: Int
    let img: String
    
    var nameInRus: String {
        switch name {
        case "PINEAPPLE":
            return "Ананас"
        case "MOZZARELLA":
            return "Моцарелла"
        case "PEPERONI":
            return "Пепперони"
        case "GREEN_PEPPER":
            return "Зеленый перец"
        case "MUSHROOMS":
            return "Грибы"
        case "BASIL":
            return "Базилик"
        case "CHEDDAR":
            return "Чеддер"
        case "PARMESAN":
            return "Пармезан"
        case "FETA":
            return "Фета"
        case "HAM":
            return "Ветчина"
        case "PICKLE":
            return "Огурец"
        case "TOMATO":
            return "Томат"
        case "BACON":
            return "Бекон"
        case "ONION":
            return "Лук"
        case "CHILE":
            return "Чили"
        case "SHRIMPS":
            return "Креветки"
        case "CHICKEN_FILLET":
            return "Куриное филе"
        case "MEATBALLS":
            return "Митболы"
        default:
            return "Неизвестный ингредиент"
        }
    }
}


struct PizzaSizeEntity: Codable {
    let name: String
    let price: Int
    
    var sizeInCm: String {
        switch name {
        case "SMALL":
            return "25 см"
        case "MEDIUM":
            return "30 см"
        case "LARGE":
            return "35 см"
        default:
            return "Unknown"
        }
    }
}

struct PizzaDoughEntity: Codable {
    let name: String
    let price: Int
    
    var doughsInStr: String {
        switch name {
        case "THIN":
            return "традиционное тесто"
        case "THICK":
            return "тонкое тесто"
        default:
            return "Unknown"
        }
    }
}
