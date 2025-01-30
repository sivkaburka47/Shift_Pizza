//
//  OrderedPizza.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 30.01.2025.
//

import Foundation

struct OrderedPizza: Codable {
    var id: String
    var name: String
    var toppings: [OrderedPizzaIngredient]
    var size: OrderedPizzaSize
    var doughs: OrderedPizzaDough
    var totalPrice: Int
    var img: String
    var quantity: Int = 1
}

struct OrderedPizzaIngredient: Codable {
    let name: String
    let cost: Int
    
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


struct OrderedPizzaSize: Codable {
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
    
    var sizeInCmFull: String {
        switch name {
        case "SMALL":
            return "Маленькая 25 см"
        case "MEDIUM":
            return "Средняя 30 см"
        case "LARGE":
            return "Большая 35 см"
        default:
            return "Unknown"
        }
    }
}

struct OrderedPizzaDough: Codable {
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
